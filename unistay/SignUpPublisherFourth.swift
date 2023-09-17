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
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            let height = geo.size.height
            NavigationStack {
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            FormHeader()
                            Group {
                                TextInputField(input: $publicationTitle, placeholderText: "Publication title", placeholderIcon: "character.cursor.ibeam")
                                TextInputField(input: $publicationDescription, placeholderText: "Publication description", placeholderIcon: "text.below.photo")
                                TextInputField(input: $rent, placeholderText: "Rent", placeholderIcon: "creditcard")
                                MenuField(items: publicationCurrencyItems, menuSelection: $publicationCurrencySelection, icon: "dollarsign.circle", placeholder: styledText(type: "Regular", size: 13, content: "Publication currency"))
                                MenuField(items: typeItems, menuSelection: $typeSelection, icon: "house.and.flag", placeholder: styledText(type: "Regular", size: 13, content: "Type"))
                            }
                            Button(action: {
                                viewModel.signUp(inputs: [publicationTitle, publicationDescription, rent, publicationCurrencySelection, typeSelection], isToggled: $isToggled)
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
            }
        }.tint(Color("BodyEmphasized")).removeFocusOnTap()
    }
}

struct SignUpPublisherFourth_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPublisherFourth()
    }
}
