//
//  TestLaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/08/23.
//

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
    var validate: () -> String
    @State var error: String
    var call: () -> Void
    var links: Bool
    var title: String
    var languages: [String] = ["System language", "English", "Portuguese", "French"]
    @State private var selectedLanguage: String = "System language"
    var postStep: Int
    var serverResponse: String?
    @State var presented: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var croppedImage: UIImage?
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            NavigationView {
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            styledText(type: "Bold", size: 22, content: "UniStay").background(GeometryReader {
                                geo in
                                Color.clear.onAppear {
                                    subtitleHeight = geo.size.height
                                }
                                
                            }).frame(height: 0).padding(.bottom, 4)
                            HStack {
                                styledText(type: "Bold", size: 34, content: title).background(GeometryReader {
                                    geo in
                                    Color.clear.onAppear {
                                        titleHeight = geo.size.height
                                    }
                                    
                                })
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
                            }.frame(height: titleHeight).padding(.bottom, 10)
                            
                            let currentStepFields = fields[currentStep]
                            ForEach(currentStepFields, id: \.self) {
                                field in
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
                                    
                                } else {
                                    Field(placeholder: styledText(type: "Regular", size: 13, content: field), text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                                }
                                
                            }
                            Button(action: {
                                let validate = validate()
                                if validate.isEmpty && currentStep == postStep {
                                    call()
                                } else {
                                    error = validate
                                }
                            }) {
                                HStack(alignment: .center) {
                                    styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                            }
                            if links {
                                NavigationLink(destination: ForgotYourPassword()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Forgot your password?").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                    }
                                }
                                
                                NavigationLink(destination: SignUpView()) {
                                    HStack {
                                        styledText(type: "Regular", size: 14, content: "Create an account").foregroundColor(Color("BodyEmphasized")).underline().padding(.vertical, 4)
                                        Image(systemName: "person.badge.plus").foregroundColor(Color("BodyEmphasized"))
                                    }
                                }
                            }
                            if(!error.isEmpty) {
                                styledText(type: "regular", size: 13, content: error).foregroundColor(.red)
                            }
                            Text(serverResponse ?? "Hey")
                            ForEach(inputs[0], id: \.self) {
                                user in
                                Text(user)
                            }
                            Spacer()
                            
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }
        
        }

    }
