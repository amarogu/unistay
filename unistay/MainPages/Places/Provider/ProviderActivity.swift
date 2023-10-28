//
//  ProviderActivities.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/10/23.
//

import SwiftUI
import NukeUI
import MapKit

struct ProviderActivity: View {
    @State private var searchText = ""
    @State var text: String = ""
    var geocoder = CLGeocoder()
    @State private var selectedFilters: [String] = []
    var filterOptions = ["Bedrooms", "Bathrooms", "Guests", "Price range"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    var size: CGFloat
    @State var name: String? = ""
    @State var country: String? = ""
    var tabSize: CGFloat
    @State private var selectionSize: CGFloat = 0
    @EnvironmentObject var user: User
    @EnvironmentObject var webSocket: WebSocketManager
    
    var lang: String = Locale.current.language.languageCode?.identifier.uppercased() ?? ""
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 6) {
                HStack(alignment: .center) {
                    Text("Activity").customStyle(type: "Bold", size: 30)
                    Spacer()
                    Menu {
                        ForEach(filterOptions, id: \.self) {
                            option in
                            Button(action: {
                                
                                if(selectedFilters.contains(option)) {
                                    selectedFilters.remove(at: selectedFilters.firstIndex(of: option) ?? -1)
                                } else {
                                    selectedFilters.append(option)
                                }
                            }) {
                                Label(option, systemImage: selectedFilters.contains(option) ? "checkmark": "")
                            }
                        }
                        
                    } label: {
                        Label(title: {Text("")}, icon: {Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24)).foregroundColor(/*@START_MENU_TOKEN@*/Color("BodyEmphasized")/*@END_MENU_TOKEN@*/)})
                    }
                }//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                Spacer()
                /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
                TextInputField(input: $text, placeholderText: "Search locations, accommodations...", placeholderIcon: "magnifyingglass", required: false)//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                Spacer()
                ZStack(alignment: .top) {
                    
                    ScrollView {
                        VStack {
                            ForEach(webSocket.newConnArray) {
                                    newConn in
                                NavigationLink(destination: ActiveProviderAccommodation(pub: newConn.publication, location: [name, country], user: user), label: {
                                        HStack(spacing: 14) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack(spacing: 4) {
                                                    Text("New user connected:").customStyle(size: 14, color: "BodyAccent")
                                                    Text(newConn.newUser.name).customStyle(size: 14, color: "BodyAccent")
                                                }.padding(.vertical, 2).padding(.horizontal, 8).background(Color("AccentColor")).cornerRadius(5)
                                                if lang == "EN" {
                                                    Text(newConn.publication.description.en).customStyle(size: 14, color: "Body").lineLimit(2).multilineTextAlignment(.leading)
                                                }
                                                if lang == "FR" {
                                                    Text(newConn.publication.description.fr).customStyle(size: 14, color: "Body").lineLimit(2).multilineTextAlignment(.leading)
                                                }
                                                if lang == "PT" {
                                                    Text(newConn.publication.description.pt).customStyle(size: 14, color: "Body").lineLimit(2).multilineTextAlignment(.leading)
                                                }
                                                
                                            }
                                            Spacer()
                                            LazyImage(url: URL(string: "http://localhost:3000/image/\(newConn.publication.images[0])")) {
                                                i in
                                                i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: size * 0.1, height: size * 0.1).scaleEffect(1.25).clipped().cornerRadius(5)
                                            }
                                        }.padding(.vertical, 10).padding(.horizontal, 14).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 4)
                                }).onAppear {
                                    let location = CLLocation(latitude: newConn.publication.location.latitude, longitude: newConn.publication.location.longitude)
                                    let locationKey = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                                    
                                    if let savedLocation = UserDefaults.standard.object(forKey: locationKey) as? [String: String] {
                                        self.name = savedLocation["name"]
                                        self.country = savedLocation["country"]
                                    } else {
                                        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                                            guard let placemark = placemarks?.first, error == nil else {
                                                print("No placemark found: \(error?.localizedDescription ?? "Unknown Error")")
                                                return
                                            }
                                            self.name = placemark.name
                                            self.country = placemark.country
                                            
                                            let locationData = ["name": self.name, "country": self.country]
                                            UserDefaults.standard.set(locationData, forKey: locationKey)
                                        }
                                    }
                                }
                                }
                            
                        }.padding(.top, selectionSize + 14).padding(.bottom, tabSize)
                    }
                    
                    VStack {
                        HStack {
                            Text("New connections").customStyle(type: "Semibold", size: 14)
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: .bottom).onAppear {
                            selectionSize = geo.size.height
                        }
                    })
                    
                }
            }.frame(maxWidth: .infinity)
        }
    }
}
