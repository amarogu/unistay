//
//  SignUpSecond.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/09/23.
//

import SwiftUI

struct SignUpSecond: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var croppedImage: UIImage?
    @State var publisherBio: String = ""
    @State var isToggled: Bool = false
    @State var presented: Bool = false
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @Environment (\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var shouldNavigate: Bool = false
    
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
                                Button(action: {
                                    presented.toggle()
                                }) {
                                    if let image = croppedImage {
                                        HStack() {
                                            Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40).padding(.trailing, 4)
                                            VStack(alignment: .leading) {
                                                styledText(type: "Regular", size: 12, content: "Update your profile picture").foregroundColor(Color("BodyEmphasized"))
                                                styledText(type: "Regular", size: 12, content: "Click here to change the profile picture you have selected").foregroundColor(Color("Body")).opacity(0.8).multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                    } else {
                                        HStack {
                                            Image(systemName: "camera").font(.system(size: 14))
                                            styledText(type: "Regular", size: 13, content: "Upload a profile picture")
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                                    }
                                }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
                                VStack {
                                    HStack(alignment: .center) {
                                        Image(systemName: "note.text").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                                        ZStack(alignment: .topLeading) {
                                            if publisherBio.isEmpty { styledText(type: "Regular", size: 13, content: "Insert a user bio") }
                                            TextField(text: $publisherBio, axis: .vertical, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized"))
                                        }
                                    }
                                }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
                                    isFocused = true
                                }
                            }
                            Button(action: {
                                let error = viewModel.validateSignUp(inputs: [croppedImage, publisherBio], isToggled: $isToggled)
                                if !error {
                                    
                                }
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
                                let _ = print("hey")
                                
                            }
                            NavigationLink(destination: SignUpThird(), isActive: $shouldNavigate) {
                                EmptyView()
                            }
                            Spacer()
                        }.frame(maxWidth: width * 0.8)
                    }.frame(maxWidth: .infinity)
                }
                
            }.tint(Color("BodyEmphasized")).removeFocusOnTap()
        }
    }
    
    struct SignUpSecond_Previews: PreviewProvider {
        static var previews: some View {
            SignUpSecond()
        }
    }
}
