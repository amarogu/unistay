//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI
import Combine

class AppText {
    
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

enum Field {
    case username
    case email
    case confirmEmail
    case password
    case confirmPass
}
    
struct SignUpBasic: View {
    //@Binding var responseData: String
    @StateObject private var validate = Validate()
    @State var username: String = ""
    @State var email: String = ""
    @State var confirmEmail: String = ""
    @State var password: String = ""
    @State var confirmPass: String = ""
    @State var isToggled: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var focusedField: Field?
    
    @State var navigator: Int = 1
    @State var shouldNavigate: Bool = false
    @State var shouldNavigateToPublisher: Bool = false
    
    @State var passChecked: Bool = false
    @State var emailchecked: Bool = false
    
    @State var name: String = ""
    @State var surname: String = ""
    
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
                                HStack {
                                    Circle().frame(width: 4.25, height: 4.25).foregroundColor(.red).padding(.top, 4.9)
                                    Text("=  required field").customStyle(size: 14)
                                }.padding(.vertical, 4)
                                Group {
                                    TextInputField(input: $username, placeholderText: "Username", placeholderIcon: "person.crop.circle", required: true)
                                    HStack {
                                        TextInputField(input: $name, placeholderText: "Name", placeholderIcon: "person.text.rectangle", required: true).frame(maxWidth: width * 0.5)
                                        TextInputField(input: $surname, placeholderText: "Surname", placeholderIcon: "", required: false, padding: 4).frame(maxWidth: width * 0.5)
                                    }
                                    TextInputField(input: $email, placeholderText: "Email address", placeholderIcon: "envelope", required: true)
                                    TextInputField(input: $confirmEmail, placeholderText: "Confirm your email address", placeholderIcon: "checkmark.circle", required: true)
                                    TextInputField(input: $password, placeholderText: "Password", placeholderIcon: "key", required: true)
                                    TextInputField(input: $confirmPass, placeholderText: "Confirm your password", placeholderIcon: "checkmark.circle", required: true)
                                    Toggle(isOn: $isToggled) {
                                        HStack {
                                            Image(systemName: "rectangle.stack.badge.person.crop").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                            Text("Sign up as a landlord").customStyle(size: 14)
                                        }
                                    }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).onTapGesture {
                                        isToggled.toggle()
                                    }.padding(.vertical, 1)
                                }
                                Button(action: {
                                    _ = validate.validateSignUp(inputs: [username, email, confirmEmail, password, confirmPass], isToggled: $isToggled)
                                    print("\(username)\(email)\(password)")
                                                    if validate.validationError.isEmpty {
                                        if isToggled {
                                            shouldNavigateToPublisher.toggle()
                                        } else {
                                            shouldNavigate.toggle()
                                        }
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        Text("Continue").customStyle(size: 14, color: "AccentColor")
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                NavigationLink(destination: SignUpSecond(username: username, email: email, password: password), isActive: $shouldNavigate) {
                                    EmptyView()
                                }
                                NavigationLink(destination: SignUpPublisherSecond(username: username, email: email, password: password, name: name, surname: surname), isActive: $shouldNavigateToPublisher) {
                                    EmptyView()
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
        }//.navigationBarHidden(true)
    }
}
    
struct Stteh_Previews: PreviewProvider {
    static var previews: some View {
        SignUpBasic()
    }
}


