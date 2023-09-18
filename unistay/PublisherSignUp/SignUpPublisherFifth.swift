//
//  SignUpPublisherFifth.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI
import PhotosUI

struct SignUpPublisherFifth: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    @State var yourLocation: String = ""
    @State var isToggled: Bool = true
    
    var visibility: [String] = ["Visible", "Invisible"]
    @State var menuSelection: String = "Visible"
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @State var croppedImage: UIImage?
    @State var presented: Bool = false
    
    @State var show: Bool = false
    @State private var photosPickerItem = [PhotosPickerItem]()
    @State private var array = [UIImage]()
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            NavigationStack {
                ZStack {
                    Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Spacer()
                            FormHeader()
                            Group {
                                TextInputField(input: $yourLocation, placeholderText: "Your location", placeholderIcon: "location.circle")
                                MenuField(items: visibility, menuSelection: $menuSelection, icon: menuSelection == "Visible" ? "eye" : "eye.slash", placeholder: styledText(type: "Regular", size: 13, content: menuSelection))
                                Button(action: {
                                    show.toggle()
                                    array = []
                                    Task {
                                        for item in photosPickerItem {
                                            if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                                DispatchQueue.main.async {
                                                    
                                                        self.array.append(image)
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                }) {
                                    if !array.isEmpty {
                                        HStack() {
                                            let _ = print("loaded")
                                            ZStack {
                                                Image(uiImage: array[0]).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4)
                                                if array.count > 1 {
                                                    Image(uiImage: array[1] ).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4).zIndex(-1).opacity(0.6).offset(x: 6, y: 3)
                                                    if array.count > 2 {
                                                        Image(uiImage: array[2] ).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 40, maxHeight: 40).scaleEffect(1.4).clipped().cornerRadius(5).padding(.trailing, 4).zIndex(-1).opacity(0.4).offset(x: 10, y: 5)
                                                    }
                                                }
                                            }.padding(.trailing, 10)
                                            VStack(alignment: .leading) {
                                                styledText(type: "Regular", size: 12, content: "Update you publication images").foregroundColor(Color("BodyEmphasized"))
                                                styledText(type: "Regular", size: 12, content: "Click here to change the images you have selected").foregroundColor(Color("Body")).opacity(0.8).multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1)
                                    } else {
                                        HStack {
                                            Image(systemName: "camera").font(.system(size: 14))
                                            styledText(type: "Regular", size: 13, content: "Upload publication images")
                                            Spacer()
                                        }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1)
                                    }
                                }.photosPicker(isPresented: $show, selection: $photosPickerItem).onChange(of: photosPickerItem) { newValue in
                                    array = []
                                    Task {
                                        for item in newValue {
                                            if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                                DispatchQueue.main.async {
                                                    self.array.append(image)
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            Button(action: {
                                viewModel.signUp(inputs: [menuSelection, yourLocation], isToggled: $isToggled)
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

struct SignUpPublisherFifth_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPublisherFifth()
    }
}
