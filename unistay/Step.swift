//
//  TestLaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/08/23.
// a

import SwiftUI
import PhotosUI



struct Step: View {
    @Binding var inputs: [[String]]
    var fields: [[String]]
    var icons: [[String]]
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Binding var currentStep: Int
    //var validate: () -> String
    @Binding var error: String
    var call: () -> Void
    var links: Bool
    var title: String
    var languages: [String] = ["System language", "English", "Portuguese", "French"]
    @State private var selectedLanguage: String = "System language"
    var postStep: Int
    @Binding var serverResponse: String?
    @State var presented: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var croppedImage: UIImage?
    @State private var isToggleOn: Bool = false
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 24)
                                styledText(type: "Bold", size: 22, content: "UniStay")
                            }.padding(.bottom, -10)
                            HStack {
                                styledText(type: "Bold", size: 34, content: title)
                                Spacer()
                                Menu {
                                    ForEach(languages, id: \.self) {
                                        language in
                                        Button(action: {
                                            selectedLanguage = language
                                        }) {
                                            Label(language, systemImage: selectedLanguage == language ? "checkmark" : "")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "globe").foregroundColor(Color("Body"))
                                        Image(systemName: "chevron.down").foregroundColor(Color("Body"))
                                    }
                                }
                            }.padding(.bottom, 10)
                            
                            let currentStepFields = fields[currentStep]
                            // in case there is an image on prof pic
                            if currentStep == 1 && croppedImage != nil && !links {
                                HStack { // Wrap ForEach in a ZStack
                                    ForEach(currentStepFields, id: \.self) {
                                        field in
                                        if field == "Upload a profile picture" {
                                            // !nil prof pic
                                            Button(action: {
                                                presented.toggle()
                                            }) {
                                                if let croppedImage {
                                                    Image(uiImage: croppedImage).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40)
                                                } else {
                                                    HStack {
                                                        Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 14))
                                                        styledText(type: "Regular", size: 13, content: "Click here to insert a profile picture")
                                                        Spacer()
                                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                                }
                                            }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
                                        } else {
                                            // general fields on step of index 1
                                            Field(placeholder: styledText(type: "Regular", size: 13, content: field), text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                        }
                                    }
                                }.padding(.bottom, 6)
                            } else {
                                // in case there is no prof pic
                                ForEach(currentStepFields, id: \.self) {
                                    field in
                                    // in case the field of prof pic is empty and it needs to be displayed
                                    if field == "Upload a profile picture" {
                                        Button(action: {
                                            presented.toggle()
                                        }) {
                                            HStack {
                                                Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 14))
                                                styledText(type: "Regular", size: 13, content: "Click here to insert a profile picture")
                                                Spacer()
                                            }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                        }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
                                    } else if field == "Sign up as a publisher account" {
                                        // in case the field is a publisher toggle
                                        Toggle(isOn: $isToggleOn) {
                                            HStack {
                                                Image(systemName: "arrow.up.doc")
                                                styledText(type: "Regular", size: 13, content: field)
                                            }
                                        }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4).onTapGesture {
                                            isToggleOn.toggle()
                                        }
                                    } else {
                                        // general fields
                                        Field(placeholder: styledText(type: "Regular", size: 13, content: field), text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                                    }
                                }
                            }
                            Button(action: {
                                call()
                            }) {
                                HStack(alignment: .center) {
                                    styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                            }
                            if links {
                                
                                NavigationLink(destination: SignUpView()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Create an account").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                        Image(systemName: "person.badge.plus").foregroundColor(Color("BodyEmphasized"))
                                    }
                                }
                                
                                NavigationLink(destination: ForgotYourPassword()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Forgot your password?").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                    }
                                }
                                
                            }
                            if !error.isEmpty {
                                styledText(type: "Regular", size: 13, content: error).foregroundColor(.red)
                                    } else if let serverResponse = serverResponse, !serverResponse.isEmpty {
                                        styledText(type: "Regular", size: 13, content: serverResponse).foregroundColor(.red)
                                    }
                            //Text(serverResponse ?? "An error occurred")
                            Spacer()
                            
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }

    }
