//
//  SignUpPublisherFourth.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI

struct SignUpPublisherFourth: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var publicationTitle: String = ""
    @State var publicationDescription: String = ""
    @State var rent: String = ""
    var publicationCurrencyItems: [String] = ["USD", "EUR", "GBP", "CAD"]
    @State var publicationCurrencySelection: String = "USD"
    @State var typeSelection: String = "On-campus"
    var typeItems = ["On-campus", "Off-campus", "Homestay"]
    @State var isToggled: Bool = true
    
    var items = ["USD", "EUR", "GBP", "CAD"]
    @State var menuSelection = "USD"
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @State var userData: [Any]
    
    @State var croppedImage: UIImage?
    @State var publisherBio: String
    @State var yourLocation: String
    
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
                                    MenuField(items: publicationCurrencyItems, menuSelection: $publicationCurrencySelection, icon: "dollarsign.circle", placeholder: styledText(type: "Regular", size: 13, content: publicationCurrencySelection))
                                    MenuField(items: typeItems, menuSelection: $typeSelection, icon: "house.and.flag", placeholder: styledText(type: "Regular", size: 13, content: typeSelection))
                                }
                                Button(action: {
                                    let data = [publicationTitle, publicationDescription, rent]
                                    let _ = viewModel.validatePublication(data: data)
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
                                NavigationLink(destination: MapSearchBarSignUpFifth(croppedImage: croppedImage, publisherBio: publisherBio, userData: userData, publicationData: [publicationTitle, publicationDescription, rent]), isActive: $shouldNavigate) {
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
