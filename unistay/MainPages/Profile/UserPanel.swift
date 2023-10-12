//
//  Profile.swift
//  unistay
//
//  Created by Gustavo Amaro on 21/08/23.
//

import SwiftUI
import NukeUI

class LocalUser {
    var _id: String = ""
    var username: String = ""
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var language: String = ""
    var password: String = ""
    var preferredLocations: [String] = []
    var isPrivate: Bool = false
    var currency: String = ""
    var savedPublications: [String] = []
    var connectedPublications: [String] = []
    var owns: [String] = []
    var profilePicture: String = ""
    var accountType: String = ""
    var bio: String = ""
    var __v: Int = 0
}

struct UserPanel: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var imageSize: CGFloat = 0
    @State private var selectedView: String = "Universities"
    var viewOptions = ["Universities", "Location", "Roommates"]
    @ObservedObject var user: ObservableUser = ObservableUser()
    @State private var selectionHeight: CGFloat = 0
    @State private var selectionWidth: CGFloat = 0
    
    @State var areDetailsExpanded: Bool = false
    @State var fullBio: Bool = false
    
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    //@StateObject var downloader = ImageDownloader()
    
    var tabSize: CGFloat
    
    @State var editProfile: Bool = false
    @State var presented: Bool = false
    @State var croppedImage: UIImage?
    
    // edit profile inputs
    
    @State var updatedBio: String = ""
    @State var updatedUser: String = ""
    @State var updatedName: String = ""
    @State var updatedSurname: String = ""
    
    @State var responseAlert: String = ""
    @State var responseAlertTitle: String = ""
    @State var isAlertOn: Bool = false
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            VStack {
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
                    }
                }.frame(maxWidth: .infinity).background(Color("BackgroundColor")).onAppear {
                    //downloader.downloadProfPic()
                    getUser {
                        userData, error in
                        if let userData = userData {
                                // Use userData
                            self.user.user = userData
                            } else if let error = error {
                                // Handle error
                                print(error)
                            }
                    }
                }
                //Spacer()
                HStack (alignment: .center) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        DisclosureGroup(
                            isExpanded: $areDetailsExpanded,
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        //checkCookies()
                                        if let bio = user.user?.bio {
                                            Text(bio).customStyle(size: 14).padding(.top, 8).padding(.trailing, width * 0.4)
                                        }
                                        Spacer()
                                    }
                                        Button (action: {
                                            fullBio.toggle()
                                        }) {
                                            HStack {
                                                if let name = user.user?.name {
                                                    Text("See \(name)'s full bio").customStyle(size: 14)
                                                }
                                                Image(systemName: "doc.badge.ellipsis").foregroundColor(Color("Body"))
                                            }
                                        }
                                        HStack {
                                            if let connectedPublications = user.user?.connectedPublications {
                                                Text("\(connectedPublications.count)").customStyle(type: "Semibold", size: 14)
                                            }
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
                                if let name = user.user?.name, let surname = user.user?.surname, let username = user.user?.username {
                                    Text("\(name) \(surname)").customStyle(type: "Semibold", size: 14)
                                    Text("@\(username)").customStyle(size: 14, color: "Body")

                                }                            } }
                        ).tint(Color("BodyEmphasized"))
                    }.padding(.top, imageSize / 1.2)
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.bottom, 10)
                
                //Spacer()
                ZStack(alignment: .top) {
                    ScrollView {
                        Rectangle().frame(maxWidth: .infinity, maxHeight: selectionHeight).foregroundColor(.clear)
                        Suggestion(width: width).padding(.bottom, 20).padding(.top, selectionHeight)
                        if selectedView == "Universities" {
                            Universities(size: width, selectionSize: selectionHeight).padding(.bottom, tabSize)
                        } else if selectedView == "Location" {
                            
                        } else {
                            
                        }
                    }
                    Selection(viewOptions: viewOptions, selectedView: $selectedView).padding(.bottom, 20).background(GeometryReader {
                        geo in
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: .init(x: 0.5, y: 0.1), endPoint: .bottom).onAppear {
                            selectionHeight = geo.size.height
                            selectionWidth = geo.size.width
                        }
                        
                    })//.padding(.top, 10)
                    
                }
                //Spacer()
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
                        if let name = user.user?.name {
                            Text("\(name)'s bio").customStyle(type: "Semibold", size: 14)
                        }
                        Image(systemName: "doc").foregroundColor(Color("Body"))
                    }
                    if let bio = user.user?.bio {
                        Text(bio).customStyle(size: 14).modifier(GetHeightModifier(height: $sheetHeight))
                    }
                }.frame(maxWidth: 300)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).presentationDetents([user.user?.bio.count ?? "".count < 110 ? .fraction(0.35) : .medium, .medium, .large])
        }).alert(responseAlertTitle, isPresented: $isAlertOn, actions: {
            Button(role: .cancel, action: {
                
            }) {
                Text("OK")
            }
        }, message: {
            Text(responseAlert)
        }).sheet(isPresented: $editProfile) {
            ZStack {
                Color("BackgroundColor")
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
                            let group = DispatchGroup()
                            editProfile.toggle()
                            group.enter()
                            if !updatedUser.isEmpty {
                                changeProperty("username", updatedUser) {
                                    value, error in
                                    if let error = error {
                                        responseAlertTitle = "Error"
                                        responseAlert = "Something went wrong. Please try again."
                                        group.leave()
                                    } else if let value = value {
                                        switch value {
                                        case .response:
                                            responseAlertTitle = "Success"
                                            responseAlert = "Data updated successfully"
                                            group.leave()
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            switch error.error {
                                            case 11000:
                                                responseAlert = "The username already exists. Please try a different one"
                                                group.leave()
                                            default:
                                                responseAlert = "Unknown error"
                                                group.leave()
                                            }
                                        }
                                    }
                                }
                            }
                            if !updatedName.isEmpty {
                                changeProperty("name", updatedName) {
                                    value, error in
                                    if let error = error {
                                        responseAlertTitle = "Error"
                                        if updatedName.count < 3 {
                                            responseAlert = "Your name needs to be at least 3 characters long"
                                        } else {
                                            responseAlert = "Something went wrong. Please try again."
                                        }
                                        group.leave()
                                    } else if let value = value {
                                        switch value {
                                        case .response:
                                            responseAlertTitle = "Success"
                                            responseAlert = "Data updated successfully"
                                            group.leave()
                                        case .error(let error):
                                            responseAlertTitle = "Error"
                                            switch error.error {
                                            case 11000:
                                                responseAlert = "The username already exists. Please try a different one"
                                                group.leave()
                                            default:
                                                responseAlert = "Unknown error"
                                                group.leave()
                                            }
                                        }
                                    }
                                }
                            }
                            group.notify(queue: .main) {
                                
                                getUser {
                                    userData, error in
                                    if let userData = userData {
                                            // Use userData
                                        self.user.user = userData
                                        } else if let error = error {
                                            // Handle error
                                            print(error)
                                        }
                                }
                                isAlertOn = true
                            }
                        }) {
                            Text("Done").customStyle(type: "Semibold", size: 14)
                        }
                    }.padding(.bottom, 24)
                    Text("General information").customStyle(size: 12, color: "Body").textCase(.uppercase).padding(.bottom, 6)
                    TextInputField(input: $updatedUser, placeholderText: "Update your username", placeholderIcon: "at", required: false)
                    TextInputField(input: $updatedName, placeholderText: "Update your name", placeholderIcon: "person.text.rectangle", required: false)
                    TextInputField(input: $updatedSurname, placeholderText: "Update your surname", placeholderIcon: "text.insert", required: false)
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

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

/*
 if !updatedName.isEmpty {
     changeProperty("name", updatedName) {
         value, error in
         if let error = error {
             responseAlertTitle = "Error"
             responseAlert = "Something went wrong. Please try again."
             isAlertOn = true
             group.leave()
         }else if let value = value {
             switch value {
             case .response:
                 
             default:
                 break
             }
         }
     }
 }
*/
