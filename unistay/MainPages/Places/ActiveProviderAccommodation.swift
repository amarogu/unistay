//
//  ActiveProviderAccommodation.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/10/23.
//

import SwiftUI
import MapKit
import NukeUI
import Nuke
import PhotosUI
import MapKit

struct ActiveProviderAccommodation: View {
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
    @State var isEditing: Bool = false
    
    @State private var newPubSheet: Bool = false
    @State private var croppedImage: UIImage? = nil
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var rent: String = ""
    @State private var menuSelection: String = "USD"
    @State private var typeSelection: String = "On-campus"
    @State private var pickedLocNames: String = ""
    @State private var pickedLocLocs: String = ""
    @State private var pickedLocCoordinates: [CLLocationDegrees?] = []
    @State private var show: Bool = false
    @State private var photosPickerItem: [PhotosPickerItem] = []
    @State private var array: [UIImage] = []
    @State private var publicationVisibility: String = "Visible"
    @State private var navigationTag: String? = nil
    
    var lang: String = Locale.current.language.languageCode?.identifier.uppercased() ?? ""
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
                                    LazyImage(url: URL(string: "http://localhost:3000/image/\(img)")) {
                                        i in
                                        i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size.width * 0.95, height: size.width * 0.75).scaleEffect(1.25).clipped()
                                    }
                                }
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)).id(pub?.images.count)
                        }
                    }.frame(maxHeight: size.width * 0.7).padding(.top, 14)
                    ScrollView {
                        if let pub = pub {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(pub.title).customStyle(type: "Semibold", size: 26)
                                if let name = location[0], let country = location[1] {
                                    HStack {
                                        Image(systemName: "location.circle").font(.system(size: 14))
                                        Text("\(name), \(country)").customStyle(size: 14)
                                        Spacer()
                                        Text("by Owner").customStyle(size: 14)
                                    }.padding(.bottom, 8)
                                }
                                Divider()
                                Text(pub.description).customStyle(size: 14).padding(.trailing, size.width * 0.3)
                            }
                            
                        }
                        Map(coordinateRegion: .constant(region), annotationItems: [getAnnotation(coordinate)]) { place in
                            MapPin(coordinate: place.coordinate, tint: .green)
                        }.frame(height: 190).cornerRadius(5).padding(.top, 16)
                        VStack(alignment: .leading) {
                            Text("Connected users").customStyle(type: "Semibold", size: 14)
                            HStack {
                                ForEach(connectedUsers) {
                                    user in
                                    let url = URL(string: "http://localhost:3000/getuserpicture/?id=\(user._id)")
                                    NavigationLink(destination: ExtraneousUserPanel(userId: user._id, tabSize: size.width * 0.75)) {
                                        LazyImage(url: url) {
                                            i in
                                            i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 58, height: 58).scaleEffect(1).clipShape(Circle())
                                        }.onAppear {
                                            let url = URL(string: "http://localhost:3000/getuserpicture/?id=\(user._id)")
                                            let request = ImageRequest(url: url)
                                            ImageCache.shared[ImageCacheKey(request: request)] = nil
                                        }
                                    }
                                }
                                Spacer()
                            }.padding(.top, 10)
                        }.padding(.top, 16)
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
                                    isEditing.toggle()
                                }) {
                                    HStack {
                                        Text("Edit").customStyle(size: 14, color: "BodyAccent")
                                        Image(systemName: "square.and.pencil").symbolEffect(.bounce.up.byLayer, value: isEditing).tint(Color("BodyAccent"))
                                    }.padding(.horizontal, 24).padding(.vertical, 14).background(Color("AccentColor")).cornerRadius(5)
                                }
                            }
                        }
                    }.padding(.horizontal, 28).padding(.vertical, 8)
                }
                
            }
        }.sheet(isPresented: $isEditing) {
            NewPublicationView(
                    newPubSheet: $isEditing,
                    croppedImage: $croppedImage,
                    title: $title,
                    description: $description,
                    rent: $rent,
                    responseAlert: $responseAlert,
                    responseAlertTitle: $responseAlertTitle,
                    isAlertOn: $isAlertOn,
                    menuSelection: $menuSelection,
                    typeSelection: $typeSelection,
                    pickedLocNames: $pickedLocNames,
                    pickedLocLocs: $pickedLocLocs,
                    pickedLocCoordinates: $pickedLocCoordinates,
                    show: $show,
                    photosPickerItem: $photosPickerItem,
                    array: $array,
                    publicationVisibility: $publicationVisibility,
                    navigationTag: $navigationTag,
                    locationManager: locationManager
                )
        }.alert(responseAlertTitle, isPresented: $isAlertOn, actions: {
            Button(role: .cancel, action: {
                
            }) {
                Text("OK")
            }
        }, message: {
            Text(responseAlert)
        })
        .onAppear {
            for saved in user.savedPublications {
                if pub?._id == saved {
                    isFav = true
                }
            }
            Task {
                do {
                    let result = try await fetchConnectedUsers(pub?._id ?? "")
                    for user in result {
                        connectedUsers.append(user)
                    }
                } catch {
                    connectedUsers = []
                }
            }
        }
    }
}
