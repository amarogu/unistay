//
//  MapSearchBarSignUpFifth.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/09/23.
//

import SwiftUI
import MapKit
import PhotosUI

struct MapSearchBarSignUpFifth: View {
    
    @State var yourLocation: String = ""
    @State var isToggled: Bool = true
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @State var croppedImage: UIImage?
    @State var publisherBio: String
    
    @State var username: String
    @State var email: String
    @State var password: String
    @State var profilePicture: UIImage?
    @State var bio: String
    @State var locatedAt: [Double?]
    @State var currency: String
    @State var publicationTitle: String
    @State var publicationDescription: String
    @State var rent: String
    @State var publicationCurrency: String
    @State var typeSelection: String
    @State var publicationVisibility: String = "Visible"
    @State var visibility: [String] = ["Visible", "Invisible"]
    @State var name: String
    @State var surname: String
    
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    
    @State var pickedLocNames: String = ""
    @State var pickedLocLocs: String = ""
    @State var pickedLocCoordinates: [CLLocationDegrees?] = []
    
    @StateObject private var validate = Validate()
    @StateObject private var registerOptions = Register()
    
    @State var presented: Bool = false
    
    @State var show: Bool = false
    @State private var photosPickerItem = [PhotosPickerItem]()
    @State private var array = [UIImage]()
    
    @State var isSignedUp: Bool = false
    
    @State var pubLoc: [Double] = []
    
    var body: some View {
        if isSignedUp {
            SignUpSuccess()
        } else {
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
                            }.padding(.all, 10).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("SearchBar"), lineWidth: 1.25)).padding(.bottom, 3)
                            MenuField(items: visibility, menuSelection: $publicationVisibility, icon: publicationVisibility == "Visible" ? "eye" : "eye.slash", placeholder: publicationVisibility).tint(Color("BodyEmphasized"))
                            Button(action: {
                                show.toggle()
                                array = []
                                Task {
                                    for item in photosPickerItem {
                                        if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                            DispatchQueue.main.async {
                                                self.array.append(image)
                                            }
                                        }
                                    }
                                }
                            }) {
                                if !array.isEmpty {
                                    HStack() {
                                        ZStack {
                                            Image(uiImage: array[0]).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4)
                                            if array.count > 1 {
                                                Image(uiImage: array[1] ).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4).zIndex(-1).opacity(0.6).offset(x: 6, y: 3)
                                                if array.count > 2 {
                                                    Image(uiImage: array[2] ).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4).zIndex(-1).opacity(0.4).offset(x: 10, y: 5)
                                                }
                                            }
                                        }.padding(.trailing, 10)
                                        VStack(alignment: .leading) {
                                            Text("Update your publication images").customStyle(size: 12)
                                            Text("Click here to change the images you have selected").customStyle(size: 12, color: "Body").opacity(0.8).multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1)
                                } else {
                                    HStack {
                                        Image(systemName: "camera").font(.system(size: 14))
                                        Text("Upload publication images").customStyle(size: 13)
                                        Spacer()
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1)
                                }
                            }.tint(Color("BodyEmphasized")).photosPicker(isPresented: $show, selection: $photosPickerItem).onChange(of: photosPickerItem) { newValue in
                                array = []
                                Task {
                                    for item in newValue {
                                        if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                            DispatchQueue.main.async {
                                                self.array.append(image)
                                            }
                                        }
                                    }
                                }
                            }
                            Button(action: {
                                let _ = validate.hasMultipleImages(images: array)
                                if pickedLocCoordinates.isEmpty {
                                    validate.validationError = "You need to tell users where your accommodation is located"
                                }
                                if let unwrappedLat = pickedLocCoordinates[0], let unwrappedLng = pickedLocCoordinates[1] {
                                    pubLoc = [unwrappedLat, unwrappedLng]
                                }
                                if validate.validationError.isEmpty {
                                    //viewModel.register(isToggled: $isToggled, userData: userData, image: userData[4] as! UIImage)
                                    
                                    if let profilePicture = profilePicture {
                                        registerOptions.registerProvider(username: username, email: email, password: password, publisherBio: publisherBio, profilePicture: profilePicture, locatedAtCoordinates: locatedAt, pubLoc: pubLoc, currency: publicationCurrency, publicationTitle: publicationTitle, publicatioDesc: publicationDescription, publicationRent: Double(rent) ?? 0, publicationType: typeSelection, visibility: publicationVisibility, images: array, name: name, surname: surname, bio: bio) {
                                            value, error in
                                            if error != nil {
                                                isSignedUp =  false
                                            } else if let response = value {
                                                if response == "User created" {
                                                    isSignedUp = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }) {
                                HStack(alignment: .center) {
                                    
                                    Text("Continue").customStyle(type: "Semibold", size: 14, color: "AccentColor")
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                            }
                            if !validate.validationError.isEmpty {
                                Text(validate.validationError).customStyle(size: 13, color: "Error").padding(.top, 4.5)
                            }
                        }.padding(.all, 30)
                        
                    }.background {
                        NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                            MapViewSignUpSelection(pickedLocNames: $pickedLocNames, pickedLocLocs: $pickedLocLocs, pickedLocCoordinates: $pickedLocCoordinates).environmentObject(locationManager).navigationBarBackButtonHidden(true).toolbarBackground(.visible, for: .automatic)
                        } label: {}.labelsHidden()
                    }//.padding(.all, 30).zIndex(10)
                    /*MapViewSelection().environmentObject(locationManager).edgesIgnoringSafeArea(.all)*/
                }
            }
        }
    }
}
