//
//  SignUpPublisherFourth.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI

struct SignUpPublisherFourth: View {
    @StateObject private var validate = Validate()
    
    var publicationCurrencyItems: [String] = ["USD", "EUR", "GBP", "CAD"]
    var typeItems = ["On-campus", "Off-campus", "Homestay"]
    @State var isToggled: Bool = true
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @State var username: String
    @State var email: String
    @State var password: String
    @State var profilePicture: UIImage?
    @State var bio: String
    @State var locatedAt: [Double?]
    @State var currency: String
    @State var publicationTitle: String = "Hello, this is a title"
    @State var publicationDescription: String = "Hello, this is a sample publication description. It envisions a lot of things, such as first second third"
    @State var rent: String = "1000"
    @State var menuSelection = "USD"
    @State var typeSelection: String = "On-campus"
    @State var name: String
    @State var surname: String
    
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
                                
                                Text("Get started by creating your first publication").customStyle(size: 13, color: "Body").padding(.top, 4)
                                Group {
                                    TextInputField(input: $publicationTitle, placeholderText: "Publication title", placeholderIcon: "character.cursor.ibeam", required: true)
                                    TextInputField(input: $publicationDescription, placeholderText: "Publication description", placeholderIcon: "text.below.photo", required: true)
                                    TextInputField(input: $rent, placeholderText: "Rent", placeholderIcon: "creditcard", required: true)
                                    MenuField(items: publicationCurrencyItems, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: menuSelection)
                                    MenuField(items: typeItems, menuSelection: $typeSelection, icon: "house.and.flag", placeholder: typeSelection)
                                }
                                Button(action: {
                                    let _ = validate.validatePublication(title: publicationTitle, desc: publicationDescription, rent: rent)
                                    if validate.validationError.isEmpty {
                                        shouldNavigate.toggle()
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        Text("Continue").customStyle(type: "Semibold", size: 14, color: "AccentColor")
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                if !validate.validationError.isEmpty {
                                    Text(validate.validationError).customStyle(size: 13, color: "Error")
                                }
                                NavigationLink(destination: MapSearchBarSignUpFifth(publisherBio: bio, username: username, email: email, password: password, bio: bio, locatedAt: locatedAt, currency: currency, publicationTitle: publicationTitle, publicationDescription: publicationDescription, rent: rent, publicationCurrency: menuSelection, typeSelection: typeSelection, name: name, surname: surname), isActive: $shouldNavigate) {
                                    EmptyView()
                                }
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
                
            }.tint(Color("BodyEmphasized")).removeFocusOnTap()
        }
    }
}
