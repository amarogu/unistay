//
//  TestLaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/08/23.
//

import SwiftUI




struct Step: View {
    @State private var fieldsInput: [String: [String: [String: String]]] = [
        "Login": [
            "login": [
                "email": "",
                "password": ""
            ]
        ],
        "SignUp": [
            "credentials": [
                "username": "",
                "email": "",
                "emailVerification": "",
                "password": "",
                "passwordVerification": ""
            ],
            "profile": [
                "profilePicture": "",
                "bio": ""
            ],
            "preferences": [
                "locations": "",
                "currency": ""
            ]
        ]
    ]
    var fields: [String: [String: [String: String]]] = [
        "Login": [
            "login": [
                "email": "E-mail address",
                "password": "Password"
            ]
        ],
        "SignUp": [
            "credentials": [
                "username": "Username",
                "email": "E-mail address",
                "emailVerification": "Confirm your e-mail address",
                "password": "Password",
                "passwordVerification": "Confirm your password"
            ],
            "profile": [
                "profilePicture": "Upload a profile picture",
                "bio": "Insert a user bio"
            ],
            "preferences": [
                "locations": "Preferred locations",
                "currency": "Preferred currency"
            ]
        ]
    ]
    var icons: [String: [String: [String: String]]] = [
        "Login": [
            "login": [
                "email": "envelope",
                "password": "key"
            ]
        ],
        "SignUp": [
            "credentials": [
                "username": "person.crop.circle",
                "email": "envelope",
                "emailVerification": "checkmark.circle",
                "password": "key",
                "passwordVerification": "checkmark.circle"
            ],
            "profile": [
                "profilePicture": "person.crop.circle",
                "bio": "bubble.circle"
            ],
            "preferences": [
                "locations": "location.circle",
                "currency": "dollarsign.circle"
            ]
        ]
    ]
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    //@State private var responseData = "a"
    @State private var loginSteps: String = "login"
    @State private var signUpSteps: String
    func validateLogin() {
        switch steps {
            case "login": do {
                let email = fieldsInput["Login"]!["login"]!["email"]
                let password = fieldsInput["Login"]!["login"]!["password"]
            }
            default: return
        }
    }
    
    func validateSignUp() {
        switch
    }
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
                            styledText(type: "Bold", size: 34, content: "Log In").background(GeometryReader {
                                geo in
                                Color.clear.onAppear {
                                    titleHeight = geo.size.height
                                }
                                
                            }).frame(height: titleHeight).padding(.bottom, 12)
                            ForEach(fields, id: \.self) {
                                field in
                                Field(placeholder: styledText(type: "Regular", size: 14, content: field).foregroundColor(Color("BodyEmphasized")), text: $text[fields.firstIndex(of: field)!], icon: icons[fields.firstIndex(of: field)!]).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4)
                            }
                            Button(action: {
                                
                            }) {
                                HStack(alignment: .center) {
                                    styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1))//.cornerRadius(5)
                            }
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

                            Spacer()
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
            }.tint(Color("BodyEmphasized"))
        }
        
        }

    }
