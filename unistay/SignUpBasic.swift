//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI
import Combine



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

enum Field {
    case username
    case email
    case confirmEmail
    case password
    case confirmPass
}
    
struct SignUpBasic: View {
    //@Binding var responseData: String
    @StateObject private var viewModel = SignUpViewModel()
    @State var username: String = "testing"
    @State var email: String = "test@test"
    @State var confirmEmail: String = "test@test"
    @State var password: String = "12345678"
    @State var confirmPass: String = "12345678"
    @State var isToggled: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var focusedField: Field?
    
    @State var navigator: Int = 1
    @State var shouldNavigate: Bool = false
    @State var shouldNavigateToPublisher: Bool = false
    
    @State var userData: [Any] = ["", "", "", "", UIImage(named: "ProfilePlaceholder") as Any, [], ""] // [username, email, password, bio, profImage, [locCoordinates], currency] -> normal user
    
    @State var passChecked: Bool = false
    @State var emailchecked: Bool = false
    
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
                                    TextInputField(input: $username, placeholderText: "Username", placeholderIcon: "person.crop.circle", required: true)
                                    TextInputField(input: $email, placeholderText: "Email address", placeholderIcon: "envelope", required: true)
                                    TextInputField(input: $confirmEmail, placeholderText: "Confirm your email address", placeholderIcon: "checkmark.circle", required: true)
                                    TextInputField(input: $password, placeholderText: "Password", placeholderIcon: "key", required: true)
                                    TextInputField(input: $confirmPass, placeholderText: "Confirm your password", placeholderIcon: "checkmark.circle", required: true)
                                    Toggle(isOn: $isToggled) {
                                        HStack {
                                            Image(systemName: "rectangle.stack.badge.person.crop").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                            styledText(type: "Regular", size: 13, content: "Sign up as a publisher account")
                                        }
                                    }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).onTapGesture {
                                        isToggled.toggle()
                                    }.padding(.vertical, 1)
                                }
                                Button(action: {
                                    let error = viewModel.validateSignUp(inputs: [username, email, confirmEmail, password, confirmPass], isToggled: $isToggled)
                                    if error {
                                        userData[0] = username
                                        userData[1] = email
                                        userData[3] = password
                                    }
                                    print("\(userData)")
                                    if viewModel.validationError.isEmpty {
                                        if isToggled {
                                            shouldNavigateToPublisher.toggle()
                                        } else {
                                            shouldNavigate.toggle()
                                        }
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                NavigationLink(destination: SignUpSecond(userData: $userData), isActive: $shouldNavigate) {
                                    EmptyView()
                                }
                                NavigationLink(destination: SignUpPublisherSecond(userData: userData), isActive: $shouldNavigateToPublisher) {
                                    EmptyView()
                                }
                                if !viewModel.validationError.isEmpty {
                                    styledText(type: "Regular", size: 13, content: viewModel.validationError).foregroundColor(.red).padding(.top, 4.5)
                                    //let _ = print("hey")
                                }
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
            }.tint(Color("BodyEmphasized")).onAppear{
                shouldNavigate = false
            }.removeFocusOnTap()
        }//.navigationBarHidden(true)
    }
}
    
struct Stteh_Previews: PreviewProvider {
    static var previews: some View {
        SignUpBasic()
    }
}


