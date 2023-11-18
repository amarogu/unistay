//
//  Login.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/09/23.
//

import SwiftUI

struct ServerResponse: Codable {
    let message: String
}

import Combine

struct Login: View {
    @StateObject private var validate = Validate()
    @State var password2: String = ""
    @State var email2: String = ""
    @State var isToggled: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var navigator: Int = 1
    @State var shouldNavigate: Bool = false
    @State var isPresented: Bool = false
    
    @State var passVisible: Bool = false
    
    @State var responseMsg: String = ""
    @State var isFullScreen: Bool = false
    @Binding var isLoggedIn: Bool
    
    @State var isPasswordVisible: Bool = false
    
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
                                LoginHeader()
                                Group {
                                    
                                    ZStack(alignment: .leading) {
                                        Image(systemName: "envelope").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                        ZStack(alignment: .topLeading) {
                                            if email2.isEmpty { HStack {
                                                Text("Email").customStyle(size: 13).padding(.leading, 28)
                                                Spacer()
                                            } }
                                            TextField(text: $email2, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).padding(.leading, 28).textInputAutocapitalization(.never).autocorrectionDisabled()
                                        }
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                        isFocused = true
                                    }
                                    ZStack(alignment: .leading) {
                                        Image(systemName: "key").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                        ZStack(alignment: .topLeading) {
                                            if password2.isEmpty { HStack {
                                                Text("Password").customStyle(size: 13).padding(.leading, 28)
                                                Spacer()
                                            } }
                                            HStack {
                                                if isPasswordVisible {
                                                    TextField(text: $password2, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).padding(.leading, 28).textInputAutocapitalization(.never).autocorrectionDisabled()
                                                } else {
                                                    SecureField(text: $password2, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized")).padding(.leading, 28).textInputAutocapitalization(.never).autocorrectionDisabled().textContentType(.password)
                                                }
                                                Button(action: {
                                                    isPasswordVisible.toggle()
                                                }) {
                                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash").font(.system(size: 14))
                                                }
                                            }
                                        }
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                        isFocused = true
                                    }
                                }
                                Button(action: {
                                    //viewModel.signUp(inputs: [email2, password2], isToggled: $isToggled)
                                    if email2.count < 5 {
                                        validate.validationError = "Your email addres must be at least 5 character long"
                                    } else {
                                        validate.validationError = ""
                                    }
                                    if !email2.contains("@") {
                                        validate.validationError = "Your email address needs to contain an @"
                                    } else {
                                        validate.validationError = ""
                                    }
                                    if validate.validationError.isEmpty {
                                        //shouldNavigate.toggle()
                                        NetworkManager.shared.login(email: email2, password: password2) {
                                            response, error in
                                                if let error = error {
                                                    // Handle error
                                                    print("Error: \(error)")
                                                    validate.validationError = "Your credentials are incorrect"
                                                } else if let response = response {
                                                    // Use the response
                                                    print("Response: \(response)")
                                                    print(response)
                                                    responseMsg = response
                                                    if responseMsg == "Logged in successfully" {
                                                        isLoggedIn = true
                                                        SessionManager.shared.isLoggedIn = true
                                                    }
                                                }
                                        }
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        Text("Continue")
                                            .customStyle(type: "Semibold", size: 14, color: "AccentColor")
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                NavigationLink(destination: Text("Content")) {
                                    HStack {
                                        Text("Forgot your password?")
                                            .customStyle(size: 13).underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
                                    }.padding(.bottom, 4).padding(.top, 3)
                                }
                                Button(action: {
                                    isFullScreen = true
                                }) {
                                    HStack {
                                        Text("Sign up")
                                            .customStyle(size: 13).underline()
                                        Image(systemName: "chevron.up").font(.system(size: 13))
                                    }.padding(.bottom, 1)
                                }
                                if !validate.validationError.isEmpty {
                                    Text(validate.validationError)
                                        .customStyle(size: 13, color: "Error")
                                    //let _ = print("hey")
                                }
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
            }.tint(Color("BodyEmphasized")).onAppear{
                shouldNavigate = false
            }
        }.navigationBarHidden(true).sheet(isPresented: $isFullScreen, content: {
                SignUpBasic()
        })
    }
}
