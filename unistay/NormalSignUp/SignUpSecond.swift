//
//  SignUpSecond.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/09/23.
//

import SwiftUI

struct SignUpSecond: View {
    @StateObject private var validate = Validate()
    
    
    @State var croppedImage: UIImage?
    @State var publisherBio: String = ""
    @State var isToggled: Bool = false
    @State var presented: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @Environment (\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var shouldNavigate: Bool = false
    
    @State var username: String
    @State var email: String
    @State var password: String
    @State var profilePicture: UIImage? = UIImage(named: "ProfilePlaceholder")
    @State var name: String
    @State var surname: String
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                geo in
                let width = geo.size.width
                
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            FormHeader()
                            Group {
                                Button(action: {
                                    presented.toggle()
                                }) {
                                    if let image = croppedImage {
                                        HStack() {
                                            Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40).padding(.trailing, 4)
                                            VStack(alignment: .leading) {
                                                
                                                Text("Update your profile picture").customStyle(size: 12)
                                                Text("Click here to change the profile picture you have selected").customStyle(size: 12, color: "Body").opacity(0.8).multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                    } else {
                                        HStack {
                                            Image(systemName: "camera").font(.system(size: 14))
                                            Text("Upload a profile picture").customStyle(size: 13)
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                    }
                                }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
                                VStack {
                                    HStack(alignment: .center) {
                                        Image(systemName: "note.text").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                        ZStack(alignment: .topLeading) {
                                            if publisherBio.isEmpty { Text("insert a user bio").customStyle(size: 13) }
                                            TextField(text: $publisherBio, axis: .vertical, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized"))
                                        }
                                    }
                                }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                    isFocused = true
                                }
                            }
                            Button(action: {
                                if publisherBio.isEmpty {
                                    let _ = validate.validateBio(bio: publisherBio)
                                }
                                if croppedImage != nil {
                                    profilePicture = croppedImage
                                }
                                if validate.validationError.isEmpty {
                                    shouldNavigate.toggle()
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
                            NavigationLink(destination: MapSearchBar(profilePicture: profilePicture, publisherBio: publisherBio, username: username, email: email, password: password, name: name, surname: surname), isActive: $shouldNavigate) {
                                EmptyView()
                            }
                            Spacer()
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
                
            }.tint(Color("BodyEmphasized")).removeFocusOnTap()
        }
    }
}
