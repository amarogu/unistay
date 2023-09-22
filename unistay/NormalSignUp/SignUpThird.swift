//
//  SignUpThird.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/09/23.
//

import SwiftUI

struct SignUpThird: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var yourLocation: String = ""
    @State var isToggled: Bool = true
    
    var items = ["USD", "EUR", "GBP", "CAD"]
    @State var menuSelection = "USD"
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var shouldNavigate: Bool = false
    
    @Binding var croppedImage: UIImage?
    @Binding var publisherBio: String
    
    @Binding var userData: [Any]
    
    var body: some View {
        NavigationStack {
            let _ = print(croppedImage)
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
                                    TextInputField(input: $yourLocation, placeholderText: "Preferred locations", placeholderIcon: "location.circle")
                                    MenuField(items: items, menuSelection: $menuSelection, icon: "dollarsign.circle", placeholder: styledText(type: "Regular", size: 13, content: menuSelection))
                                }
                                Button(action: {
                                    if yourLocation.isEmpty {
                                        viewModel.validationError = "You need to select at least one location"
                                    } else {
                                        viewModel.validationError = ""
                                        userData[4] = yourLocation
                                    }
                                    if !yourLocation.isEmpty && viewModel.validationError.isEmpty {
                                        viewModel.register(isToggled: $isToggled, userData: userData)
                                        viewModel.login(email: userData[1] as! String, password: userData[3] as! String)
                                        shouldNavigate.toggle()
                                    }
                                    if let image = croppedImage {
                                        viewModel.uploadImage(image: image)
                                    }
                                    if !publisherBio.isEmpty {
                                        viewModel.updateBio(bio: publisherBio)
                                    }
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
                                /*NavigationLink(destination: SignUpPublisherFourth(), isActive: $shouldNavigate) {
                                    EmptyView()
                                }*/
                                Spacer()
                            }.frame(maxWidth: width * 0.8)
                        }.frame(maxWidth: .infinity)
                    }
                
            }.tint(Color("BodyEmphasized")).removeFocusOnTap()
        }
    }

}
