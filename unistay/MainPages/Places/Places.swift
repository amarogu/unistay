//
//  Places.swift
//  unistay
//
//  Created by Gustavo Amaro on 07/08/23.
//

import SwiftUI
import MapKit


struct Places: View {
    @State private var searchText = ""
    // @State private var searchText3 = "a"
    @State var text: String = ""
    @State private var selectedFilters: [String] = []
    var filterOptions = ["Bedrooms", "Bathrooms", "Guests", "Price range"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    var size: CGFloat
    var tabSize: CGFloat
    @State private var selectionSize: CGFloat = 0
    
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    
    @State var pickedLocNames: String = ""
    @State var pickedLocLocs: String = ""
    @State var pickedLocCoordinates: [CLLocationDegrees?] = []
    
    var height: CGFloat
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 6) {
                HStack(alignment: .center) {
                    Text("Accommodations").customStyle(type: "Bold", size: 30)
                    Spacer()
                    Menu {
                        //Button(action: {}, label: {Text("Button")})
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
                if locationManager.searchText.isEmpty {
                    Spacer()
                }
                /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
                VStack(alignment: .leading) {
                    SearchBar(placeholder: "Set your location", text: $locationManager.searchText).background(Color("SearchBar")).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).tint(Color("BodyEmphasized"))
                    
                    if let places = locationManager.fetchedPlaces, !places.isEmpty {
                        List {
                            Section {
                                ForEach(places, id: \.self) {
                                    place in
                                    Button(action: {
                                        if let coordinate = place.location?.coordinate {
                                            locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                            locationManager.addDraggablePin(coordinate: coordinate)
                                            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                        }
                                        navigationTag = "MAPVIEW"
                                    }) {
                                        HStack(spacing: 15) {
                                            
                                            Text(place.name ?? "").customStyle(size: 14)
                                            Text(place.locality ?? "").customStyle(size: 14).opacity(0.8)
                                        }.padding(.vertical, 6)
                                    }
                                }.listRowBackground(Color.clear).listRowSeparator(.hidden)
                            } header: {
                                Text("SELECT A PLACE").customStyle(size: 13)
                            }
                        }.listStyle(.plain).frame(maxHeight: .infinity).background(Color("SearchBar").opacity(0.4)).cornerRadius(5).padding(.vertical, 1)
                    } else {
                        if !locationManager.searchText.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }.padding(.all, 8).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1)
                        } else {
                            Button(action: {
                                if let coordinate = locationManager.userLocation?.coordinate {
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                                navigationTag = "MAPVIEW"
                            }) {
                                HStack(alignment: .center) {
                                    Text("Use your current location").customStyle(size: 14, color: "Body")
                                    Image(systemName: "location.north.circle").foregroundColor(Color("Body"))
                                    
                                }.padding(.vertical, 1).padding(.leading, 14)
                            }
                            if !pickedLocNames.isEmpty {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Currently selected").customStyle(size: 13).padding(.bottom, 10)
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                
                                                Text(pickedLocNames).customStyle(size: 13)
                                                Text(pickedLocLocs).customStyle(size: 13, color: "Body").opacity(0.8)
                                                Spacer()
                                                Button(action: {
                                                    pickedLocNames = ""
                                                    pickedLocLocs = ""
                                                    pickedLocCoordinates = []
                                                }) {
                                                    Image(systemName: "minus.circle").font(.system(size: 13)).foregroundColor(.red)
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }.padding(.vertical, 10).padding(.horizontal, 14).background(Color("SearchBar").opacity(0.8)).cornerRadius(5).padding(.top, 1)
                            }
                        }
                    }
                }.padding(.bottom, 3)//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                Spacer()
                if locationManager.searchText.isEmpty {
                    ZStack(alignment: .top) {
                        
                        if(selectedView == "Saved") {
                            //Accomodation()
                            AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                        } else if(selectedView == "Recommended") {
                            AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                        } else {
                            AccomodationsGroup(size: size, tabSize: tabSize, selectionSize: selectionSize)
                        }
                        
                        Selection(viewOptions: viewOptions, selectedView: $selectedView).padding(.bottom, 48).background(GeometryReader {
                            geo in
                            LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: .bottom).onAppear {
                                selectionSize = geo.size.height
                            }
                        })//.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12)
                        
                    }
                } else {
                    
                }
            }.frame(maxWidth: .infinity)
        }.background {
            NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                MapViewSignUpSelection(pickedLocNames: $pickedLocNames, pickedLocLocs: $pickedLocLocs, pickedLocCoordinates: $pickedLocCoordinates).environmentObject(locationManager).navigationBarBackButtonHidden(true).toolbarBackground(.visible, for: .automatic)
            } label: {}.labelsHidden()
        }.onDisappear {
            locationManager.searchText = ""
        }
        }
    }
    
    /*struct Places_Previews: PreviewProvider {
        static var previews: some View {
            Places()
        }
    }*/

