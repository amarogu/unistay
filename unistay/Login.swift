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
                                    TextInputField(input: $email2, placeholderText: "Email", placeholderIcon: "envelope", required: false)
                                    TextInputField(input: $password2, placeholderText: "Password", placeholderIcon: "key", required: false)
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
                                NavigationLink(destination: SignUpBasic()) {
                                    HStack {
                                        Text("Sign up")
                                            .customStyle(size: 13).underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
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
                
            }.removeFocusOnTap()
        }.navigationBarHidden(true)
    }
}
