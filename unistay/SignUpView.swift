//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI
import Combine

struct ServerResponseSignup: Codable {
    let responseMessage: String
}

class SignUpViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
    @Published var validationError: String = ""
    var cancellables = Set<AnyCancellable>()
    func signUp(inputs: [String], isToggled: Binding<Bool>) {
        if !validateSignUp(inputs: inputs, isToggled: isToggled) {
            return
        }
        let url = URL(string: "http://localhost:3000/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData: [String: Any] = ["user": ["username": inputs[0], "email": inputs[1], "language": "English", "accountType": "normal", "password": inputs[3]] as [String : Any]]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        request.httpBody = jsonData

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 401 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ServerResponseSignup.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.serverResponse = response.responseMessage
            })
            .store(in: &cancellables)
    }
    func validateSignUp(inputs: [String], isToggled: Binding<Bool>) -> Bool {
        let username = inputs[0]
        let email = inputs[1]
        let emailConfirm = inputs[2]
        let password = inputs[3]
        let passwordConfirm = inputs[4]
        if username.count < 3 || username.count > 20 {
            validationError = "The username needs to be 3 to 20 characters long"
            return false
        }
        if email != emailConfirm {
            validationError = "The e-mail addresses do not match"
            return false
        }
        if password != passwordConfirm {
            validationError = "The passwords do not match"
            return false
        }
        if email.count < 5 || email.count > 50 || !email.contains("@") {
            validationError = "The e-mail address is not valid"
            return false
        }
        if password.count < 8 || password.count > 50 {
            validationError = "The password does not fit the criteria"
            return false
        }
            
        validationError = ""
        return true
    }
}

public struct RemoveFocusOnTapModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
#if os (iOS)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
#elseif os(macOS)
            .onTapGesture {
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
#endif
    }
}

extension View {
    public func removeFocusOnTap() -> some View {
        modifier(RemoveFocusOnTapModifier())
    }
}

struct Field: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var confirmEmail: String = ""
    @State var password: String = ""
    @State var confirmPass: String = ""
    var body: some View {
        
    }
}

struct SignUp: View {
    //@Binding var responseData: String
    @StateObject private var viewModel = SignUpViewModel()
    @State var username: String = ""
    @State var email: String = ""
    @State var confirmEmail: String = ""
    @State var password: String = ""
    @State var confirmPass: String = ""
    @State var isToggled: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Spacer()
                        FormHeader()
                        VStack {
                            HStack {
                                Image(systemName: "person.crop.circle").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                ZStack(alignment: .leading) {
                                    if username.isEmpty { styledText(type: "regular", size: 13, content: "Username") }
                                    TextField("", text: $username, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                }
                            }
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                            isFocused = true
                        }
                        VStack {
                            HStack {
                                Image(systemName: "envelope").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                ZStack(alignment: .leading) {
                                    if email.isEmpty { styledText(type: "regular", size: 13, content: "Email address") }
                                    TextField("", text: $email, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                }
                            }
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                            isFocused = true
                        }
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                ZStack(alignment: .leading) {
                                    if confirmEmail.isEmpty { styledText(type: "regular", size: 13, content: "Confirm your email address") }
                                    TextField("", text: $confirmEmail, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                }
                            }
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                            isFocused = true
                        }
                        VStack {
                            HStack {
                                Image(systemName: "key").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                ZStack(alignment: .leading) {
                                    if password.isEmpty { styledText(type: "regular", size: 13, content: "Password") }
                                    TextField("", text: $password, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                }
                            }
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                            isFocused = true
                        }
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                ZStack(alignment: .leading) {
                                    if confirmPass.isEmpty { styledText(type: "regular", size: 13, content: "Confirm your password") }
                                    TextField("", text: $confirmPass, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13)).textInputAutocapitalization(.never).focused($isFocused)
                                }
                            }
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                            isFocused = true
                        }
                        Toggle(isOn: $isToggled) {
                            HStack {
                                Image(systemName: "rectangle.stack.badge.person.crop").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                styledText(type: "Regular", size: 13, content: "Sign up as a publisher account")
                            }
                        }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).onTapGesture {
                            isToggled.toggle()
                        }.padding(.vertical, 1)
                        Button(action: {
                            viewModel.signUp(inputs: [username, email, confirmEmail, password, confirmPass], isToggled: $isToggled)
                        }) {
                            HStack(alignment: .center) {
                                styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                    Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                            }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                        }
                        if !viewModel.validationError.isEmpty {
                            styledText(type: "Regular", size: 13, content: viewModel.validationError).foregroundColor(.red)
                            let _ = print("hey")
                        }
                        Spacer()
                    }.frame(maxWidth: width * 0.8)
                }.frame(maxWidth: .infinity)
            }
        }.tint(Color("BodyEmphasized")).removeFocusOnTap()
    }
}

struct Stteh_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}


