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
    @State var presentedPublication: Bool = false
    @State private var croppedImagePublication: UIImage?
    @Binding var isToggleOn: Bool
    var fieldTypes: [String] = ["text", "emptyImg", "selectedImg", "menu"]
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
                        if currentStep == 1 && croppedImage != nil && !links {
                            HStack {
                                ForEach(currentStepFields, id: \.self) {
                                    (field: String) in
                                    if field == "Upload a profile picture" {
                                        SelectedPicField(presented: $presented, croppedImage: $croppedImage)
                                    } else {
                                        TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                                    }
                                }
                            }//.padding(.bottom, 6)
                        } else if currentStep == 4 && croppedImagePublication != nil && !links {
                            HStack {
                                ForEach(currentStepFields, id: \.self) {
                                    (field: String) in
                                    if field == "Publication images" {
                                        SelectedPicField(presented: $presentedPublication, croppedImage: $croppedImagePublication)
                                    } else {
                                        TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                                    }
                                }
                            }
                        } else {
                            ForEach(currentStepFields, id: \.self) {
                                field in
                                if field == "Upload a profile picture" {
                                    EmptyPicField(presented: $presented, croppedImage: $croppedImage).padding(.bottom, 4)
                                } else if field == "Sign up as a publisher account" {
                                    ToggleField(isToggleOn: $isToggleOn, field: field).padding(.bottom, 4)
                                } else if field == "Type" {
                                    MenuField(items: ["On-campus", "Off-campus", "Homestay"], menuSelection: "On-campus", icon: icons[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field))
                                } else if field == "Publication visibility" {
                                    MenuField(items: ["Public", "Private"], menuSelection: "Public", icon: icons[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field))
                                } else if field == "Publication images" {
                                    EmptyPicField(presented: $presentedPublication, croppedImage: $croppedImagePublication).padding(.bottom, 4)
                                } else {
                                    TextInputField(text: $inputs[currentStep][currentStepFields.firstIndex(of: field)!], placeholder: styledText(type: "Regular", size: 13, content: field), icon: icons[currentStep][currentStepFields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
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
                            Spacer()
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }
    }
