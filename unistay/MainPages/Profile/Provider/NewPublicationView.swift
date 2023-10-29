//
//  NewPublicationView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/10/23.
//

import SwiftUI
import MapKit
import PhotosUI

struct NewPublicationView: View {
    @Binding var newPubSheet: Bool
    @Binding var croppedImage: UIImage?
    @Binding var title: String
    @Binding var description: String
    @Binding var rent: String
    @Binding var responseAlert: String
    @Binding var responseAlertTitle: String
    @Binding var isAlertOn: Bool
    @Binding var menuSelection: String
    @Binding var typeSelection: String
    @Binding var pickedLocNames: String
    @Binding var pickedLocLocs: String
    @Binding var pickedLocCoordinates: [CLLocationDegrees?]
    @Binding var show: Bool
    @Binding var photosPickerItem: [PhotosPickerItem]
    @Binding var array: [UIImage]
    @Binding var publicationVisibility: String
    @Binding var navigationTag: String?
    @StateObject var locationManager: LocationManager
    var publicationCurrencyItems: [String] = ["USD", "EUR", "GBP", "CAD"]
    var typeItems: [String] = ["On-campus", "Off-campus", "Homestay"]
    var visibility: [String] = ["Visible", "Invisible"]
    
    @State private var showAlert = false
        @State private var alertTitle = ""
        @State private var alertMessage = ""
    var body: some View {
            NavigationStack {
                ZStack {
                    Color("BackgroundColor").ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Button(action: {
                                    croppedImage = nil
                                    newPubSheet = false
                                }) {
                                    Text("Cancel").customStyle(type: "Semibold", size: 14)
                                }
                                Spacer()
                                Button(action: {
                                    
                                    if array.count < 3 {
                                                alertTitle = "Error"
                                                alertMessage = "Please select at least three pictures."
                                                showAlert = true
                                                return
                                            }

                                            // Check if location is not selected
                                            if pickedLocCoordinates.isEmpty {
                                                alertTitle = "Error"
                                                alertMessage = "Please select a location."
                                                showAlert = true
                                                return
                                            }

                                        
                                    newPubSheet = false
                                    
                                    
                                    
                                    Task {
                                        
                                        do {
                                            let res = try await postPublication(title: ["original": title, "en": "", "pt": "", "fr": ""], description: ["original": description, "en": "", "pt": "", "fr": ""], rent: Double(rent) ?? 0, currency: menuSelection, type: typeSelection, postLanguage: "en", visibility: publicationVisibility, pubLoc: pickedLocCoordinates, images: array)
                                            isAlertOn = true
                                            responseAlertTitle = "Success"
                                            responseAlert = res.message
                                        } catch {
                                            print(error)
                                            isAlertOn = true
                                            responseAlertTitle = "Error"
                                            responseAlert = "An error occurred while uploading your accommodation. Please try again."
                                        }
                                    }
                                }) {
                                    Text("Publish your accommodation").customStyle(type: "Semibold", size: 14)
                                }
                            }.padding(.bottom, 24)
                            Text("About your accommodation").customStyle(size: 12, color: "Body").textCase(.uppercase).padding(.bottom, 6)
                            TextInputField(input: $title, placeholderText: "Title", placeholderIcon: "character.cursor.ibeam", required: false)
                            TextInputField(input: $description, placeholderText: "Description", placeholderIcon: "text.below.photo", required: false)
                            TextInputField(input: $rent, placeholderText: "Rent", placeholderIcon: "creditcard", required: false)
                            MenuField(items: publicationCurrencyItems, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: menuSelection)
                            MenuField(items: typeItems, menuSelection: $typeSelection, icon: "house.and.flag", placeholder: typeSelection)
                        }
                        Text("Location, visibility and images").customStyle(size: 12, color: "Body").textCase(.uppercase).padding(.bottom, 6).padding(.top, 14)
                        VStack(alignment: .leading, spacing: 8) {
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
                                }.listStyle(.plain).frame(maxHeight: 300).background(Color("SearchBar").opacity(0.4)).cornerRadius(5).padding(.vertical, 1)
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
                    }.padding(.all, 16)
                }.background {
                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                    MapViewSignUpSelection(pickedLocNames: $pickedLocNames, pickedLocLocs: $pickedLocLocs, pickedLocCoordinates: $pickedLocCoordinates).environmentObject(locationManager).navigationBarBackButtonHidden(true).toolbarBackground(.visible, for: .automatic)
                }label: {}.labelsHidden()
            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

