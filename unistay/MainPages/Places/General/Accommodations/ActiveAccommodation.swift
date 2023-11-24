//
//  ActiveAccommodation.swift
//  unistay
//
//  Created by Gustavo Amaro on 02/10/23.
//

import SwiftUI
import MapKit
import CoreLocation
import NukeUI
import Nuke

struct ActiveAccommodation: View {
    @State var responseAlertTitle: String = ""
    @State var responseAlert: String = ""
    @State var isAlertOn: Bool = false
    @State private var currentPage: Int = 0
    var pub: AccommodationResponse?
    @State var location: [String?] = []
    @StateObject var locationManager: LocationManager = .init()
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    @StateObject var user: User
    @State var connectedUsers: [Participant] = []
    @State var connectedUsersProgress: String = ""
    @State var isFav: Bool = false
    @State var hasConnected: Bool = false
    @State var pubOwner: String = ""
    var lang: String = Locale.current.language.languageCode?.identifier.uppercased() ?? ""
    @State var connected: Bool = false
    @State var requests: [String] = []
    var body: some View {
        let coordinate = CLLocationCoordinate2D(latitude: pub?.location.latitude ?? 0, longitude: pub?.location.longitude ?? 0)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        GeometryReader { geometry in
            let size = geometry.size
            ZStack(alignment: .top) {
                Color("BackgroundColor").ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    VStack {
                        if !(pub?.images.isEmpty ?? false) {
                            TabView {
                                ForEach(pub?.images ?? [], id: \.self) { img in
                                    LazyImage(url: URL(string: "\(Global.shared.apiUrl)image/\(img)")) {
                                        i in
                                        if i.isLoading {
                                            Rectangle().foregroundStyle(Color("Gray")).aspectRatio(contentMode: .fill).frame(width: size.width * 0.95, height: size.width * 0.75).scaleEffect(1.25).clipped()
                                        } else {
                                            i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size.width * 0.95, height: size.width * 0.75).scaleEffect(1.25).clipped()
                                        }
                                    }
                                }
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)).id(pub?.images.count)
                        }
                    }.frame(maxHeight: size.width * 0.7).padding(.top, 14)
                    ScrollView {
                        if let pub = pub {
                            VStack(alignment: .leading, spacing: 10) {
                                if lang == "EN" {
                                    Text(pub.title.en).customStyle(type: "Semibold", size: 26)
                                }
                                if lang == "FR" {
                                    Text(pub.title.fr).customStyle(type: "Semibold", size: 26)
                                }
                                if lang == "PT" {
                                    Text(pub.title.pt).customStyle(type: "Semibold", size: 26)
                                }
                                if let name = location[0], let country = location[1] {
                                    HStack {
                                        Image(systemName: "location.circle").font(.system(size: 14))
                                        HStack {
                                            Text("\(name), \(country)").customStyle(size: 14)
                                            Spacer()
                                        }.frame(maxWidth: 240).padding(.leading, 10)
                                        Spacer()
                                        NavigationLink(destination: ExtraneousUserPanel(userId: pub.owner, tabSize: size.width, pub: pub), label: {
                                            Text("by \(pubOwner)").customStyle(size: 14).onAppear {
                                                Task {
                                                    do {
                                                        let response = try await getExtraneousUser(pub.owner)
                                                        pubOwner = response.username
                                                        print(response)
                                                    } catch {
                                                        print(error)
                                                    }
                                                }
                                            }
                                        })
                                    }.padding(.vertical, 8)
                                }
                                Divider()
                                if lang == "EN" {
                                    Text(pub.description.en).customStyle(size: 14)
                                }
                                if lang == "FR" {
                                    Text(pub.description.fr).customStyle(size: 14)
                                }
                                if lang == "PT" {
                                    Text(pub.description.pt).customStyle(size: 14)
                                }
                            }
                            
                        }
                        Map(coordinateRegion: .constant(region), annotationItems: [getAnnotation(coordinate)]) { place in
                            MapPin(coordinate: place.coordinate, tint: .green)
                        }.frame(height: 190).cornerRadius(5).padding(.top, 16)
                        VStack(alignment: .leading) {
                            Text("Connected users").customStyle(type: "Semibold", size: 14)
                            HStack {
                                if connectedUsers.isEmpty {
                                    Text("There are no users connected.").customStyle(size: 14)
                                }
                                ForEach(connectedUsers) {
                                    userInstance in
                                    let url = URL(string: "\(Global.shared.apiUrl)getuserpicture/?id=\(userInstance._id)")
                                    if user._id == userInstance._id {
                                        NavigationLink(destination: ZStack {
                                            Color("BackgroundColor").ignoresSafeArea(.all)
                                            UserPanel(tabSize: size.width).padding(.horizontal, 18)
                                        }) {
                                            LazyImage(url: url) {
                                                i in
                                                i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle())
                                            }
                                        }
                                    } else {
                                        NavigationLink(destination: ExtraneousUserPanel(userId: userInstance._id, tabSize: size.width * 0.75, pub: pub)) {
                                            LazyImage(url: url) {
                                                i in
                                                i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle())
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }.padding(.top, 10)
                        }.padding(.top, 16)
                        if requests.contains(where: {$0 == user._id}) == true {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.green)
                                    Text("You have requested this place! You will hear back from the landlord soon.").customStyle(size: 14)
                                }
                                Button(action: {
                                    Task {
                                        do {
                                            let res = try await revokeRequest(pub?._id ?? "")
                                            if res.message == "Request revoked successfully" {
                                                responseAlertTitle = "Success"
                                                responseAlert = "You have successfully revoked this request"
                                                isAlertOn = true
                                                requests.removeAll(where: {$0 == user._id})
                                            } else if res.message == "User has not requested this publication" {
                                                responseAlertTitle = "Error"
                                                responseAlert = "You have not requested a stay here"
                                                isAlertOn = true
                                            } else {
                                                responseAlertTitle = "Error"
                                                responseAlert = "An error occurred"
                                                isAlertOn = true
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }) {
                                    Text("Revoke request").customStyle(size: 14, color: "Error")
                                }
                            }.padding(.top, 16)
                        }
                    }.padding(.horizontal, 20).padding(.vertical, 18)
                    Spacer()
                    Divider()
                    VStack {
                        HStack {
                            if let pub = pub {
                                VStack(alignment: .leading) {
                                    Text("\(pub.rent)").customStyle(type: "Semibold", size: 18)
                                    Text("/month").customStyle(size: 14, color: "Body")
                                }
                            }
                            Spacer()
                            HStack(spacing: 18) {
                                Button(action: {
                                    Task {
                                        do {
                                            withAnimation {
                                                isFav.toggle()
                                            }
                                            let res = try await savePublication(pub?._id ?? "", isFav)
                                            
                                        } catch { print(error) }
                                    }
                                }) {
                                    Image(systemName: isFav ? "heart.fill" : "heart").tint(Color("BodyEmphasized"))
                                }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
                                Button(action: {
                                    Task {
                                        do {
                                            
                                            print(connectedUsers.contains(where: { $0._id == user._id }))
                                            if let id = pub?._id {
                                                if connectedUsers.contains(where: { $0._id == user._id }) == true {
                                                    let res = try await disconnectUser(id)
                                                    DispatchQueue.main.async {
                                                        if res.message != "User disconnected from publication successfully" {
                                                            responseAlertTitle = "Error"
                                                            responseAlert = "Could not disconnect you from this publication"
                                                            isAlertOn = true
                                                        } else {
                                                            responseAlertTitle = "Success"
                                                            responseAlert = "Disconnected from this publication"
                                                            isAlertOn = true
                                                            connectedUsers.removeAll(where: { $0._id == user._id })
                                                            requests.removeAll(where: {$0 == user._id})
                                                        }
                                                    }
                                                } else {
                                                    let res = try await connectUser(id)
                                                    DispatchQueue.main.async {
                                                        if res.message == "Could not add user: User is already connected to this publication" {
                                                            responseAlertTitle = "Error"
                                                            responseAlert = "You are already connected to this publication"
                                                            isAlertOn = true
                                                        } else {
                                                            responseAlertTitle = "Success"
                                                            responseAlert = "Connected to this publication"
                                                            isAlertOn = true
                                                            connectedUsers.append(Participant(_id: user._id, username: user.username))
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                        connected.toggle()
                                    }
                                }) {
                                    Text(connected ? "Disconnect" : "Connect").customStyle(size: 14, color: "BodyAccent").padding(.horizontal, 24).padding(.vertical, 14).background(Color("AccentColor")).cornerRadius(5)
                                }
                                if connected {
                                    Button(action: {
                                        Task {
                                            do {
                                                let res = try await requestPublication(pub?._id ?? "")
                                                DispatchQueue.main.async {
                                                    if res.message == "Request sent successfully" {
                                                        responseAlert = "You have submitted a request for this place. You should hear back from the landlord soon."
                                                        responseAlertTitle = "Success"
                                                        isAlertOn = true
                                                        requests.append(user._id)
                                                    } else {
                                                        responseAlert = "An error occurred while making this request."
                                                        responseAlertTitle = "Error"
                                                        isAlertOn = true
                                                    }
                                                }
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }) {
                                        Text("Request").customStyle(size: 14, color: "BodyAccent").padding(.horizontal, 24).padding(.vertical, 14).background(Color("AccentColor")).cornerRadius(5)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 28).padding(.vertical, 8)
                }
            }
        }.alert(responseAlertTitle, isPresented: $isAlertOn, actions: {
            Button(role: .cancel, action: {
                
            }) {
                Text("OK")
            }
        }, message: {
            Text(responseAlert)
        })
        .onAppear {
            requests = pub?.requests ?? []
            for saved in user.savedPublications {
                if pub?._id == saved {
                    isFav = true
                }
            }
            if connectedUsers.isEmpty {
                Task {
                    do {
                        let result = try await fetchConnectedUsers(pub?._id ?? "")
                        for user in result {
                            connectedUsers.append(user)
                        }
                        if connectedUsers.contains(where: { $0._id == user._id }) == true {
                            connected = true
                        }
                    } catch {
                        connectedUsers = []
                    }
                }
            }
        }
    }
}

class IdentifiablePointAnnotation: MKPointAnnotation, Identifiable {
    let id = UUID()
}

func getAnnotation(_ coordinate: CLLocationCoordinate2D) -> IdentifiablePointAnnotation {
        let annotation = IdentifiablePointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
