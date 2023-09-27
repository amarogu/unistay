//
//  SignUpPublisherFourth.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI

struct SignUpPublisherFourth: View {
    @StateObject private var viewModel = SignUpViewModel()
    
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
    @State var locatedAt: [Double]
    @State var currency: String
    @State var publicationTitle: String = ""
    @State var publicationDescription: String = ""
    @State var rent: String = ""
    @State var menuSelection = "USD"
    @State var typeSelection: String = "On-campus"
    
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
                                    TextInputField(input: $publicationTitle, placeholderText: "Publication title", placeholderIcon: "character.cursor.ibeam", required: true)
                                    TextInputField(input: $publicationDescription, placeholderText: "Publication description", placeholderIcon: "text.below.photo", required: true)
                                    TextInputField(input: $rent, placeholderText: "Rent", placeholderIcon: "creditcard", required: true)
                                    MenuField(items: publicationCurrencyItems, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: styledText(type: "Regular", size: 13, content: menuSelection))
                                    MenuField(items: typeItems, menuSelection: $typeSelection, icon: "house.and.flag", placeholder: styledText(type: "Regular", size: 13, content: typeSelection))
                                }
                                Button(action: {
                                    let _ = viewModel.validatePublication(title: publicationTitle, desc: publicationDescription, rent: rent)
                                    if viewModel.validationError.isEmpty {
                                        shouldNavigate.toggle()
                                    }
                                }) {
                                    HStack(alignment: .center) {
                                        styledText(type: "Semibold", size: 14, content: "Continue").foregroundColor(Color("AccentColor"))
                                        Image(systemName: "arrow.right.circle").foregroundColor(Color("AccentColor"))
                                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("AccentColorClear").opacity(0.18)).clipShape(RoundedRectangle(cornerRadius:5)).overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("AccentColorClear"), lineWidth: 1)).padding(.vertical, 1)//.cornerRadius(5)
                                }
                                if !viewModel.validationError.isEmpty {
                                    styledText(type: "Regular", size: 13, content: viewModel.validationError).foregroundColor(.red)
                                }
                                NavigationLink(destination: MapSearchBarSignUpFifth(publisherBio: bio, username: username, email: email, password: password, bio: bio, locatedAt: locatedAt, currency: currency, publicationTitle: publicationTitle, publicationDescription: publicationDescription, rent: rent, publicationCurrency: menuSelection, typeSelection: typeSelection), isActive: $shouldNavigate) {
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
