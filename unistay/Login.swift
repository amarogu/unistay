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

class LoginViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
        @Published var validationError: String = ""
        var cancellables = Set<AnyCancellable>()

        func login(email: String, password: String) {
            if !validateLogin(email: email, password: password) {
                return
            }

            let url = URL(string: "http://localhost:3000/login")!
            // remaining URLSession code...
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let bodyData = ["email": email, "password": password]
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
            request.httpBody = jsonData

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 401 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .decode(type: ServerResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    self?.serverResponse = response.message
                })
                .store(in: &cancellables)
        }

        func validateLogin(email: String, password: String) -> Bool {
            if email.count < 5 || email.count > 50 || !email.contains("@") {
                validationError = "The e-mail address must contain '@' and be at least 5 characters long"
                return false
            }
            if password.count < 8 {
                validationError = "The password does not contain the minimum amount of characters"
                return false
            }
            validationError = ""
            return true
        }
}

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
    
    @State var navigationTag: String?
    
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
                                                if email2.isEmpty { styledText(type: "Regular", size: 13, content: "Email address") }
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
                                                if password2.isEmpty { styledText(type: "Regular", size: 13, content: "Password") }
                                                if !passVisible {
                                                    SecureField("", text: $password2).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                                } else {
                                                    TextField("", text: $password2, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                                }
                                            }
                                            Button(action: {
                                                passVisible.toggle()
                                            }) {
                                                Image(systemName: !passVisible ? "eye.slash" : "eye").font(.system(size: 14))
                                            }
                                        }
                                    }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                        isFocused = true
                                    }
                                    
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
                                        viewModel.login(email: email2, password: password2) {
                                            response, error in
                                                if let error = error {
                                                    // Handle error
                                                    print("Error: \(error)")
                                                } else if let response = response {
                                                    // Use the response
                                                    print("Response: \(response)")
                                                    print(response)
                                                    responseMsg = response
                                                    if responseMsg == "Logged in successfully" {
                                                        isLoggedIn = true
                                                        navigationTag = "LOGGEDIN"
                                                    }
                                                }
                                        }
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        styledText(type: "Semibold", size: 14, content: "Continue", color: "AccentColor")
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                NavigationLink(destination: Text("Content")) {
                                    HStack {
                                        styledText(type: "Regular", size: 13, content: "Forgot your password?").foregroundColor(Color("BodyEmphasized")).underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
                                    }.padding(.bottom, 4).padding(.top, 3)
                                }
                                NavigationLink(destination: SignUpBasic()) {
                                    HStack {
                                        styledText(type: "Regular", size: 13, content: "Sign up").foregroundColor(Color("BodyEmphasized")).underline()
                                        Image(systemName: "chevron.right").font(.system(size: 13))
                                    }.padding(.bottom, 1)
                                }
                                if !viewModel.validationError.isEmpty {
                                    styledText(type: "Regular", size: 13, content: viewModel.validationError, color: "Error")
                                    //let _ = print("hey")
                                }
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
            }.background(
                NavigationLink(tag: "LOGGEDIN", selection: $navigationTag) {
                    ContentView(isLoggedIn: $isLoggedIn)
                } label: {}.labelsHidden()
            ).tint(Color("BodyEmphasized")).onAppear{
                shouldNavigate = false
            }.removeFocusOnTap()
        }.navigationBarHidden(true)
    }
}
