//
//  ProviderPanel.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/10/23.
//

import SwiftUI
import Nuke
import NukeUI
import MapKit
import PhotosUI

struct ProviderPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    @State private var selectedView: String = "Universities"
    var viewOptions = ["Universities", "Location", "Roommates"]
    @EnvironmentObject var user: User
    @State private var selectionHeight: CGFloat = 0
    @State private var selectionWidth: CGFloat = 0
    
    @State var areDetailsExpanded: Bool = false
    @State var fullBio: Bool = false
    
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    var tabSize: CGFloat
    
    @State var editProfile: Bool = false
    @State var presented: Bool = false
    @State var croppedImage: UIImage?
    
    // edit profile inputs
    
    @State var updatedBio: String = ""
    @State var title: String = "Hahhahaahahhahah"
    @State var description: String = "Hhahahahhahahahhahahhahahahahhahahahahahhahahhahahahhahahahhahahahhahahhahaha"
    @State var rent: String = "1479"
    
    @State var responseAlert: String = ""
    @State var responseAlertTitle: String = ""
    @State var isAlertOn: Bool = false
    
    @State var newPubSheet: Bool = false
    
    var publicationCurrencyItems: [String] = ["USD", "EUR", "GBP", "CAD"]
    var typeItems = ["On-campus", "Off-campus", "Homestay"]
    @State var menuSelection = "USD"
    @State var typeSelection: String = "On-campus"
    
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag: String?
    
    @State var pickedLocNames: String = ""
    @State var pickedLocLocs: String = ""
    @State var pickedLocCoordinates: [CLLocationDegrees?] = []
    
    @StateObject private var validate = Validate()
    @StateObject private var registerOptions = Register()
    
    
    @State var show: Bool = false
    @State private var photosPickerItem = [PhotosPickerItem]()
    @State private var array = [UIImage]()
    
    @State var isSignedUp: Bool = false
    
    @State var pubLoc: [Double] = []
    
    @State var publicationVisibility: String = "Visible"
    @State var visibility: [String] = ["Visible", "Invisible"]
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image("ProfileBackground").resizable().aspectRatio(contentMode: .fill).frame(width: width, height: 90).scaleEffect(1.15).clipped().cornerRadius(15)
                    LazyImage(url: URL(string: "http://localhost:3000/user/profilepicture")) {
                        i in
                        i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: width * 0.2, height: width * 0.2).scaleEffect(1).clipShape(Circle()).overlay(Circle().stroke(Color("Gray"), lineWidth: 3.5)).background(GeometryReader {
                            geo in
                            Color.clear.onAppear {
                                imageSize = geo.size.width
                            }
                        }).offset(.init(width: imageSize / 2, height: imageSize / 2))
                    }.onAppear {
                        let url = URL(string: "http://localhost:3000/user/profilepicture")!
                        let request = ImageRequest(url: url)
                        ImageCache.shared[ImageCacheKey(request: request)] = nil
                    }
                }.frame(maxWidth: .infinity).background(Color("BackgroundColor"))
                //Spacer()
                HStack (alignment: .center) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        DisclosureGroup(
                            isExpanded: $areDetailsExpanded,
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        //checkCookies()
                                        
                                            Text(user.bio).customStyle(size: 14).padding(.top, 8).padding(.trailing, width * 0.4)
                                        
                                        Spacer()
                                    }
                                    Button (action: {
                                        fullBio.toggle()
                                    }) {
                                        HStack {
                                            
                                                Text("See \(user.name)'s full bio").customStyle(size: 14)
                                            
                                            Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                                        }
                                    }
                                    HStack {
                                        
                                        Text("\(user.connectedPublications.count)").customStyle(type: "Semibold", size: 14)
                                        
                                        Text("Connections").customStyle(size: 14)
                                    }
                                    Button(action: {
                                        editProfile.toggle()
                                    }) {
                                        HStack {
                                            Text("Edit your profile").customStyle(size: 14)
                                            Image(systemName: "square.and.pencil").foregroundStyle(Color("BodyEmphasized"))
                                        }
                                    }
                                }
                            },
                            label: { VStack(alignment: .leading, spacing: 2) {
                                
                                Text("\(user.name) \(user.surname)").customStyle(type: "Semibold", size: 14)
                                Text("@\(user.username)").customStyle(size: 14, color: "Body")
                                    
                                             } }
                        ).tint(Color("BodyEmphasized"))
                    }.padding(.top, imageSize / 1.2)
                    Spacer()
                    
                }.frame(maxWidth: .infinity).padding(.bottom, 10)
                ZStack(alignment: .topLeading) {
                    
                    ScrollView {
                        Rectangle().foregroundStyle(Color.clear).frame(height: selectionHeight)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your publications").customStyle(type: "Semibold", size: 14).padding(.top, 12)
                        Button(action: {
                            newPubSheet = true
                        }) {
                            HStack {
                                Text("Create a publication").customStyle(size: 14)
                                Image(systemName: "plus.circle").font(.system(size: 14))
                                Spacer()
                            }
                        }.tint(Color("BodyEmphasized"))
                    }.frame(maxWidth: .infinity).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: .init(x: 0.5, y: 0.1), endPoint: .bottom).onAppear {
                            selectionHeight = geo.size.height
                            selectionWidth = geo.size.width
                        }
                        
                    })
                }
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor")).edgesIgnoringSafeArea(.bottom).sheet(isPresented: $fullBio, content: {
            VStack(alignment: .trailing) {
                Button(action: {
                    fullBio.toggle()
                }) {
                    Text("Done").customStyle(type: "Semibold", size: 14)
                }.alignmentGuide(.top, computeValue: { dimension in
                    1
                }).padding(.top, 34)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        
                            Text("\(user.name)'s bio").customStyle(type: "Semibold", size: 14)
                        
                        Image(systemName: "doc").foregroundColor(Color("Body"))
                    }
                    
                    Text(user.bio).customStyle(size: 14).modifier(GetHeightModifier(height: $sheetHeight))
                    
                }.frame(maxWidth: 300)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).presentationDetents([user.bio.count ?? "".count < 110 ? .fraction(0.35) : .medium, .medium, .large])
        }).alert(responseAlertTitle, isPresented: $isAlertOn, actions: {
            Button(role: .cancel, action: {
                
            }) {
                Text("OK")
            }
        }, message: {
            Text(responseAlert)
        }).sheet(isPresented: $newPubSheet) {
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
                                    newPubSheet = false
                                    Task {
                                        do {
                                            let res = try await postPublication(title: title, description: description, rent: Double(rent) ?? 0, currency: menuSelection, type: typeSelection, postLanguage: "en", visibility: publicationVisibility, pubLoc: pickedLocCoordinates, images: array)
                                            isAlertOn = true
                                            responseAlertTitle = "Success"
                                            responseAlert = res.message
                                        } catch {
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
            }
        }.sheet(isPresented: $editProfile) {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea(.all)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button(action: {
                            croppedImage = nil
                            editProfile.toggle()
                        }) {
                            Text("Cancel").customStyle(type: "Semibold", size: 14)
                        }
                        Spacer()
                        Button(action: {
                            editProfile.toggle()
                            if !title.isEmpty {
                                Task {
                                    do {
                                        let result = try await changeProperty("username", title)
                                        switch result {
                                        case .response(let response):
                                            responseAlertTitle = "Success"
                                            responseAlert = response.message
                                            isAlertOn = true
                                            self.user.username = title
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            switch error.error {
                                            case 11000:
                                                responseAlert = "The username already exists. Please try a different one"
                                                isAlertOn = true
                                            default:
                                                responseAlert = "Unknown error"
                                                isAlertOn = true
                                            }
                                        }
                                    } catch {
                                        responseAlertTitle = "Error"
                                        responseAlert = "Something went wrong. Please try again."
                                        isAlertOn = true
                                    }
                                }
                            }
                            if !description.isEmpty {
                                Task {
                                    do {
                                        let result = try await changeProperty("name", description)
                                        
                                        switch result {
                                        case .response(let response):
                                            responseAlertTitle = "Success"
                                            responseAlert = response.message
                                            self.user.name = description
                                            isAlertOn = true
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            responseAlert = "Error code: \(error.error)"
                                            isAlertOn = true
                                        }
                                    } catch {
                                        responseAlertTitle = "Error"
                                        if description.count < 3 {
                                            responseAlert = "Your name needs to be at least 3 characters long"
                                        } else {
                                            responseAlert = "Something went wrong. Please try again."
                                        }
                                        isAlertOn = true
                                    }
                                }
                            }
                            if !rent.isEmpty {
                                Task {
                                    do {
                                        let result = try await changeProperty("surname", rent)
                                        switch result {
                                        case .response(let response):
                                            responseAlertTitle = "Success"
                                            responseAlert = response.message
                                            self.user.surname = rent
                                            isAlertOn = true
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            responseAlert = "Error code: \(error.error)"
                                            isAlertOn = true
                                        }
                                    } catch {
                                        responseAlertTitle = "Error"
                                        if rent.count < 3 {
                                            responseAlert = "Your surname needs to be at least 3 characters long"
                                        } else {
                                            responseAlert = "Something went wrong. Please try again."
                                        }
                                        isAlertOn = true
                                    }
                                }
                            }
                            if !updatedBio.isEmpty {
                                Task {
                                    do {
                                        let result = try await changeProperty("bio", updatedBio)
                                        switch result {
                                        case .response(let response):
                                            responseAlertTitle = "Success"
                                            responseAlert = response.message
                                            self.user.bio = updatedBio
                                            isAlertOn = true
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            responseAlert = "Error code: \(error.error)"
                                            isAlertOn = true
                                        }
                                    } catch {
                                        responseAlertTitle = "Error"
                                        if updatedBio.count < 10 {
                                            responseAlert = "Your bio needs to be at least 10 characters long"
                                        } else {
                                            responseAlert = "Something went wrong. Please try again."
                                        }
                                        isAlertOn = true
                                    }
                                }
                            }
                            if croppedImage != nil {
                                Task {
                                    do {
                                        _ = try await updateProfilePicture(croppedImage)
                                        responseAlertTitle = "Success"
                                        responseAlert = "Data updated successfully"
                                        isAlertOn = true
                                    } catch {
                                        responseAlertTitle = "Error"
                                        responseAlert = "Could not update your photo"
                                        isAlertOn = true
                                    }
                                }
                            }
                        }) {
                            Text("Done").customStyle(type: "Semibold", size: 14)
                        }
                    }.padding(.bottom, 24)
                    Text("General information").customStyle(size: 12, color: "Body").textCase(.uppercase).padding(.bottom, 6)
                    TextInputField(input: $title, placeholderText: "Update your username", placeholderIcon: "at", required: false)
                    TextInputField(input: $description, placeholderText: "Update your name", placeholderIcon: "person.text.rectangle", required: false)
                    TextInputField(input: $rent, placeholderText: "Update your surname", placeholderIcon: "text.insert", required: false)
                    Text("Profile picture and bio").customStyle(size: 12, color: "Body").textCase(.uppercase).padding(.bottom, 6).padding(.top, 10)
                    HStack {
                        if croppedImage == nil {
                            LazyImage(url: URL(string: "http://localhost:3000/user/profilepicture")) {
                                i in
                                i.image?.resizable().aspectRatio(contentMode: .fill).frame(width: 40, height: 40).scaleEffect(1).clipShape(Circle())
                            }
                        }
                        Button(action: {
                            presented.toggle()
                        }) {
                            if let image = croppedImage {
                                HStack() {
                                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40).padding(.trailing, 4)
                                    VStack(alignment: .leading) {
                                        Text("Update your profile picture").customStyle(type: "Regular", size: 12)
                                        Text("Click here to change the profile picture you have selected").customStyle(type: "Regular", size: 12, color: "Body").opacity(0.8).multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                            } else {
                                HStack {
                                    Image(systemName: "camera").font(.system(size: 14)).tint(Color("BodyEmphasized"))
                                    Text("Update your profile picture").customStyle(type: "Regular", size: 13)
                                    Spacer()
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                            }
                        }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
                    }
                    TextInputField(input: $updatedBio, placeholderText: "Update your bio", placeholderIcon: "note.text", required: false)
                }.padding(.all, 16)
            }
        }
    }
}
