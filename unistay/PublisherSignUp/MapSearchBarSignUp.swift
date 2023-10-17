//
//  MapSearchBarSignUp.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/09/23.
//

import SwiftUI
import MapKit

struct MapSearchBarSignUp: View {
     
    @StateObject private var validate = Validate()
    
    @State var yourLocation: String = ""
    @State var isToggled: Bool = true
    
    var items = ["USD", "EUR", "GBP", "CAD"]
    @State var menuSelection = "USD"
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @State var username: String
    @State var email: String
    @State var password: String
    @State var profilePicture: UIImage?
    @State var bio: String
    @State var locatedAt: [Double?] = []
    @State var name: String
    @State var surname: String
    
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    
    @State var pickedLocNames: String = ""
    @State var pickedLocLocs: String = ""
    @State var pickedLocCoordinates: [CLLocationDegrees?] = []
    
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
                                                            print(pickedLocCoordinates)
                                                        }) {
                                                            Image(systemName: "minus.circle").font(.system(size: 13)).foregroundColor(.red)
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 14).background(Color("SearchBar").opacity(0.8)).cornerRadius(5).padding(.top, 1)
                                    }
                                }
                            }
                            Text("You need to provide your location").customStyle(size: 13, color: "Body").padding(.horizontal, 14).padding(.vertical, 1)
                            NavigationLink(destination: EmptyView()) {
                                Text("understand why we need your location").customStyle(size: 13, color: "Body").padding(.horizontal, 14).padding(.vertical, 1).underline().multilineTextAlignment(.leading)
                            }
                        }.padding(.all, 10).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("SearchBar"), lineWidth: 1.25)).padding(.bottom, 3)
                        Text("Set a currency you will see on other accommodations").customStyle(size: 13, color: "Body").padding(.top, 4)
                        MenuField(items: items, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: menuSelection).tint(Color("BodyEmphasized"))
                        Button(action: {
                            
                            if pickedLocNames == "" {
                                validate.validationError = "You need to select at least one location"
                            } else {
                                validate.validationError = ""
                                
                                    
                                        
                                if let unwrappedLat = pickedLocCoordinates[0], let unwrappedLng = pickedLocCoordinates[1] {
                                    
                                    locatedAt = [pickedLocCoordinates[0], pickedLocCoordinates[1]]
                                                print(locatedAt)
                                }
                                            
                                        
                                    
                                
                            }
                            
                            
                                if !pickedLocNames.isEmpty && validate.validationError.isEmpty {
                                    
                                    shouldNavigate.toggle()
                                }
                            
                        }) {
                            HStack(alignment: .center) {
                                Text("Continue").customStyle(type: "Semibold", size: 14, color: "AccentColor")
                                Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                            }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                        }
                        NavigationLink(destination: SignUpPublisherFourth(username: username, email: email, password: password, profilePicture: profilePicture, bio: bio, locatedAt: locatedAt, currency: menuSelection, name: name, surname: surname), isActive: $shouldNavigate) {
                            EmptyView()
                        } // The problem is the view is navigating before the located at is uploaded, I guess
                        if !validate.validationError.isEmpty {
                            Text(validate.validationError).customStyle(size: 13, color: "Error").padding(.top, 4)
                        }
                    }.background {
                        NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                            MapViewSignUpSelection(pickedLocNames: $pickedLocNames, pickedLocLocs: $pickedLocLocs, pickedLocCoordinates: $pickedLocCoordinates).environmentObject(locationManager).navigationBarBackButtonHidden(true).toolbarBackground(.visible, for: .automatic)
                        } label: {}.labelsHidden()
                    }.padding(.all, 30).zIndex(10)
                    /*MapViewSelection().environmentObject(locationManager).edgesIgnoringSafeArea(.all)*/
                }
            }
        }
    }
}

struct MapViewSignUpSelection: View {
    @Binding var pickedLocNames: String
    @Binding var pickedLocLocs: String
    @Binding var pickedLocCoordinates: [CLLocationDegrees?]
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewHelper().environmentObject(locationManager).edgesIgnoringSafeArea(.all)
            
            if let place = locationManager.pickedPlacemark {
                HStack() {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Text("Confirm your location").customStyle(size: 13)
                            Image(systemName: "checkmark.circle").font(.system(size: 13))
                        }
                        HStack {
                       
                            Text(place.name ?? "").customStyle(size: 13)
                            Text(place.locality ?? "").customStyle(size: 13).opacity(0.8)
                        }
                        Button(action: {
                            pickedLocLocs = place.locality ?? ""
                            pickedLocNames = place.name ?? ""
                            pickedLocCoordinates = [locationManager.pickedLocation?.coordinate.latitude, locationManager.pickedLocation?.coordinate.longitude]
                            presentationMode.wrappedValue.dismiss()
                            print(pickedLocCoordinates)
                        }) {
                            HStack {
                                Text("Confirm").customStyle(size: 14)
                                Image(systemName: "arrow.forward").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                            }.padding(.horizontal, 10).padding(.vertical, 4).background(Color.green.opacity(0.4)).cornerRadius(5).padding(.top, 8)
                        }
                    }
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.vertical, 14).padding(.horizontal, 24).background(Color("SearchBar")).cornerRadius(14).padding(.horizontal, 24).padding(.bottom, 44).padding(.top, 24)
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
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}
