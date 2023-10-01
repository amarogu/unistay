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
    @StateObject private var viewModel = SignUpViewModel()
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
    @Binding var isLoggedIn: Bool
    
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
                                    VStack {
                                        HStack {
                                            Image(systemName: "person.crop.circle").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                            ZStack(alignment: .leading) {
                                                if email2.isEmpty { localizedText(type: "Regular", size: 13, contentKey: "Email address") }
                                                TextField("", text: $email2, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                            }
                                        }
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                        isFocused = true
                                    }
                                    VStack {
                                        HStack {
                                            Image(systemName: "key").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                            ZStack(alignment: .leading) {
                                                if password2.isEmpty { localizedText(type: "Regular", size: 13, contentKey: "Password") }
                                                if !passVisible {
                                                    SecureField("", text: $password2).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never)
                                                } else {
                                                    TextField("", text: $password2, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never)
                                                }
                                            }
                                            Button(action: {
                                                passVisible.toggle()
                                            }) {
                                                Image(systemName: !passVisible ? "eye.slash" : "eye").font(.system(size: 14))
                                            }
                                        }
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity)
                                    
                                }
                                Button(action: {
                                    //viewModel.signUp(inputs: [email2, password2], isToggled: $isToggled)
                                    if email2.count < 5 {
                                        viewModel.validationError = "Your email addres must be at least 5 character long"
                                    } else {
                                        viewModel.validationError = ""
                                    }
                                    if !email2.contains("@") {
                                        viewModel.validationError = "Your email address needs to contain an @"
                                    } else {
                                        viewModel.validationError = ""
                                    }
                                    if viewModel.validationError.isEmpty {
                                        //shouldNavigate.toggle()
                                        SignUpViewModel.NetworkManager.shared.login(email: email2, password: password2) {
                                            response, error in
                                                if let error = error {
                                                    // Handle error
                                                    print("Error: \(error)")
                                                    viewModel.validationError = "Your credentials are incorrect"
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
                                        localizedText(type: "Semibold", size: 14, contentKey: "Continue", color: "AccentColor")
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                NavigationLink(destination: Text("Content")) {
                                    HStack {
                                        localizedText(type: "Regular", size: 13, contentKey: "Forgot your password?").underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
                                    }.padding(.bottom, 4).padding(.top, 3)
                                }
                                NavigationLink(destination: SignUpBasic()) {
                                    HStack {
                                        localizedText(type: "Regular", size: 13, contentKey: "Sign up").underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
                                    }.padding(.bottom, 1)
                                }
                                if !viewModel.validationError.isEmpty {
                                    localizedText(type: "Regular", size: 13, contentKey: viewModel.validationError, color: "Error")
                                    //let _ = print("hey")
                                }
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
            }.tint(Color("BodyEmphasized")).onAppear{
                shouldNavigate = false
            }.removeFocusOnTap()
        }.navigationBarHidden(true)
    }
}
