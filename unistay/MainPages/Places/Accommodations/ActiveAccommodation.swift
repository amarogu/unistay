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
    @State private var currentPage: Int = 0
    @State private var listOfPages: [UIImage?] = []
    @State private var fakedPages: [UIImage?] = []
    var pub: AccommodationResponse?
    @State var images: [UIImage?]
    @State var location: [String?] = []
    @StateObject var locationManager: LocationManager = .init()
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    @StateObject var user: User
    @State var connectedUsers: [Participant] = []
    @State var connectedUsersProgress: String = ""
    var body: some View {
        let coordinate = CLLocationCoordinate2D(latitude: pub?.location.latitude ?? 0, longitude: pub?.location.longitude ?? 0)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack(alignment: .top) {
                Color("BackgroundColor").ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    VStack {
                        if !fakedPages.isEmpty {
                            TabView(selection: $currentPage) {
                                ForEach(fakedPages.indices, id: \.self) { index in
                                    Image(uiImage: fakedPages[index] ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: size.width * 0.95, height: size.width * 0.75).scaleEffect(1.25).clipped().cornerRadius(5).tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .overlay(alignment: .bottom) {
                                PageControl(numberOfPages: listOfPages.count, currentPage: $currentPage)
                                    .offset(y: 0)
                            }
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
                            Button(action: {
                                Task {
                                    do {
                                        if let id = pub?._id {
                                            let res = try await connectUser(id)
                                            
                                        }
                                    } catch {
                                        
                                    }
                                }
                            }) {
                                Text("Connect").customStyle(size: 14, color: "BodyAccent").padding(.horizontal, 24).padding(.vertical, 14).background(Color("AccentColor")).cornerRadius(5)
                            }
                        }
                    }.padding(.horizontal, 28).padding(.vertical, 8)
                }
                
            }
        }
        .onAppear {
            guard fakedPages.isEmpty else { return }
            for image in images {
                listOfPages.append(image)
            }
            createCarousel(true)
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
    
    func createCarousel(_ setFirstPageAsCurrentPage: Bool = false) {
        fakedPages.removeAll()
        fakedPages.append(contentsOf: listOfPages)
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
