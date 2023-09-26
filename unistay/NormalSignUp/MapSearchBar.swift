//
//  SearchBar.swift
//  unistay
//
//  Created by Gustavo Amaro on 22/09/23.
//

import SwiftUI
import MapKit

struct MapSearchBar: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var yourLocation: String = ""
    @State var isToggled: Bool = true
    
    var items = ["USD", "EUR", "GBP", "CAD"]
    @State var menuSelection = "USD"
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @State var profilePicture: UIImage?
    @State var publisherBio: String
    @State var username: String
    @State var email: String
    @State var password: String
    @State var doubleLocCoordinates: [Double] = []
    
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    
    @State var pickedLocNames: [String] = []
    @State var pickedLocLocs: [String] = []
    @State var pickedLocCoordinates: [[CLLocationDegrees?]] = []
    
    var body: some View {
        NavigationView {
            GeometryReader {
                geo in
                let height = geo.size.height
                ZStack(alignment: .center) {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        FormHeader()
                        VStack(alignment: .leading) {
                            SearchBar(placeholder: styledText(type: "Regular", size: 13, content: "Find a place"), text: $locationManager.searchText).background(Color("SearchBar")).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).tint(Color("BodyEmphasized"))
                            
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
                                                    styledText(type: "Regular", size: 14, content: place.name ?? "")
                                                    styledText(type: "Regular", size: 14, content: place.locality ?? "").opacity(0.8)
                                                }.padding(.vertical, 6)
                                            }
                                        }.listRowBackground(Color.clear).listRowSeparator(.hidden)
                                    } header: {
                                        styledText(type: "Regular", size: 13, content: "SELECT A PLACE")
                                    }
                                }.listStyle(.plain).frame(maxHeight: height * 0.4).background(Color("SearchBar").opacity(0.4)).cornerRadius(5).padding(.vertical, 1)
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
                                            styledText(type: "Regular", size: 14, content: "Use your current location").foregroundColor(Color("Body"))
                                            Image(systemName: "location.north.circle").foregroundColor(Color("Body"))
                                            
                                        }.padding(.vertical, 1).padding(.leading, 14)
                                    }
                                    if !pickedLocNames.isEmpty {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                styledText(type: "regular", size: 13, content: "Currently selected").padding(.bottom, 10)
                                                VStack(alignment: .leading, spacing: 10) {
                                                    ForEach(pickedLocNames, id:\.self) {
                                                        loc in
                                                        HStack {
                                                            styledText(type: "Regular", size: 13, content: loc)
                                                            styledText(type: "Regular", size: 13, content: pickedLocLocs[pickedLocNames.firstIndex(of: loc)!]).foregroundColor(Color("Body").opacity(0.8))
                                                            Spacer()
                                                            Button(action: {
                                                                pickedLocNames.remove(at: pickedLocNames.firstIndex(of: loc) ?? 0)
                                                                pickedLocLocs.remove(at: pickedLocNames.firstIndex(of: loc) ?? 0)
                                                                pickedLocCoordinates.remove(at: pickedLocNames.firstIndex(of: loc) ?? 0)
                                                                print(pickedLocCoordinates)
                                                            }) {
                                                                Image(systemName: "minus.circle").font(.system(size: 13)).foregroundColor(.red)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 14).background(Color("SearchBar").opacity(0.8)).cornerRadius(5).padding(.top, 1)
                                    }
                                }
                            }
                        }.padding(.all, 10).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("SearchBar"), lineWidth: 1.25)).padding(.bottom, 3)
                        MenuField(items: items, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: styledText(type: "Regular", size: 13, content: menuSelection)).tint(Color("BodyEmphasized"))
                        Button(action: {
                            if pickedLocCoordinates.isEmpty {
                                viewModel.validationError = "You need to select at least one location"
                            } else {
                                viewModel.validationError = ""
                            }
                            if !pickedLocCoordinates.isEmpty && viewModel.validationError.isEmpty {
                                //viewModel.register(isToggled: $isToggled, userData: userData)
                                if let coordinates = pickedLocCoordinates as? [[Optional<Double>]] {
                                    for coordinate in coordinates {
                                        if let latitude = coordinate[0].flatMap({ $0 }),
                                           let longitude = coordinate[1].flatMap({ $0 }) {
                                            print("Latitude: \(latitude), Longitude: \(longitude)")
                                            doubleLocCoordinates = [latitude, longitude]
                                        }
                                    }
                                }
                                viewModel.register(username: username, email: email, password: password, publisherBio: publisherBio, profilePicture: profilePicture, doubleLocCoordinates: doubleLocCoordinates)
                                //shouldNavigate.toggle()
                                //viewModel.testRequest()
                            }
                            //viewModel.testRequest()
                            
                        }) {
                            HStack(alignment: .center) {
                                styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                            }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                        }
                        if !viewModel.validationError.isEmpty {
                            styledText(type: "Regular", size: 13, content: viewModel.validationError).foregroundColor(.red).padding(.top, 1.25)
                        }
                    }.background {
                        NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                            MapViewSelection(pickedLocNames: $pickedLocNames, pickedLocLocs: $pickedLocLocs, pickedLocCoordinates: $pickedLocCoordinates).environmentObject(locationManager).navigationBarBackButtonHidden(true).toolbarBackground(.visible, for: .automatic)
                        } label: {}.labelsHidden()
                    }.padding(.all, 30).zIndex(10)
                    /*MapViewSelection().environmentObject(locationManager).edgesIgnoringSafeArea(.all)*/
                }
            }
        }
    }
}

struct MapViewSelection: View {
    @Binding var pickedLocNames: [String]
    @Binding var pickedLocLocs: [String]
    @Binding var pickedLocCoordinates: [[CLLocationDegrees?]]
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewHelper().environmentObject(locationManager).edgesIgnoringSafeArea(.all)
            
            if let place = locationManager.pickedPlacemark {
                HStack() {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            styledText(type: "Regular", size: 13, content: "Confirm your location")
                            Image(systemName: "checkmark.circle").font(.system(size: 13))
                        }
                        HStack {
                            styledText(type: "Regular", size: 13, content: place.name ?? "").foregroundColor(Color("BodyEmphasized"))
                            styledText(type: "Regular", size: 13, content: place.locality ?? "").foregroundColor(Color("Body")).opacity(0.8)
                        }
                        Button(action: {
                            if !pickedLocNames.contains(locationManager.pickedPlacemark?.name ?? "") {
                                pickedLocNames.append(locationManager.pickedPlacemark?.name ?? "")
                                pickedLocLocs.append(locationManager.pickedPlacemark?.locality ?? "")
                                // TODO: FIX WHEN USER LOCATION IS USED PICKEDCOORDINATES = [[NIL, NIL]]
                                pickedLocCoordinates.append([locationManager.pickedLocation?.coordinate.latitude, locationManager.pickedLocation?.coordinate.longitude])
                            }
                            print(pickedLocCoordinates)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                styledText(type: "Regular", size: 14, content: "Confirm").foregroundColor(Color("BodyEmphasized"))
                                Image(systemName: "arrow.forward").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                            }.padding(.horizontal, 10).padding(.vertical, 4).background(Color.green.opacity(0.4)).cornerRadius(5).padding(.top, 8)
                        }
                    }
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.vertical, 14).padding(.horizontal, 24).background(Color("SearchBar")).cornerRadius(5).padding(.horizontal, 10).padding(.bottom, 44).padding(.top, 24)
            }
        }.toolbar(content: {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "x.circle").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
            }
        }).onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlacemark = nil
        }
    }
}

struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
