//
//  ProfilePictureSelection.swift
//  unistay
//
//  Created by Gustavo Amaro on 02/09/23.
//

import SwiftUI
import PhotosUI

// MARK: - View Extensions

extension View {
    @ViewBuilder
    func cropImagePicker(crop: Crop, show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(crop: crop, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    var crop: Crop
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    init(crop: Crop, show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.crop = crop
    }
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDiag: Bool = false
    @State private var showCropView: Bool = false
    var body: some View {
        content.photosPicker(isPresented: $show, selection: $photosItem).onChange(of: photosItem) {
            newValue in
            if let newValue {
                Task {
                    if let imageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        await MainActor.run(body: {
                            selectedImage = image
                            //showDiag.toggle()
                            showCropView.toggle()
                        })
                    }
                }
            }
        }.fullScreenCover(isPresented: $showCropView) {
            selectedImage = nil
        } content: {
            CropView(crop: crop, image: selectedImage) {
                croppedImage, status in
                
            }
        }
    }
}

struct CropView: View {
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        GeometryReader {
            geo in
            //let width = geo.size.width
            let height = geo.size.height
            ZStack(alignment: .top) {
                //Text("hey")
                ImageView().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor").opacity(0.8).blur(radius: 5)).edgesIgnoringSafeArea(.all)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "x.circle")
                    }.foregroundColor(Color("BodyEmphasized"))
                    Spacer()
                    styledText(type: "Semibold", size: 14, content: "Crop").foregroundColor(Color("BodyEmphasized"))
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "x.circle")
                    }.foregroundColor(Color("BodyEmphasized"))
                }.frame(maxWidth: .infinity).padding(.vertical, height * 0.02).padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            if let image {
                Image(uiImage: image).resizable().aspectRatio(contentMode: .fill).frame(size)
            }
        }.overlay(content: {
            Grids()
        }).frame(cropSize).cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
    }
    
    @ViewBuilder
    func Grids() -> some View {
        
        ZStack {
            HStack {
                ForEach(1...4, id: \.self) {
                    rec in
                    Rectangle().fill(Color("White")).opacity(0.65).frame(maxWidth: 1, maxHeight: .infinity)
                    if rec.self != 4 {
                        Spacer()
                    }
                }
            }
            VStack {
                ForEach(1...4, id: \.self) {
                    rec in
                    Rectangle().fill(Color("White")).opacity(0.65).frame(maxWidth: .infinity, maxHeight: rec.self == 1 || rec.self == 4 ? 0 : 1)
                    if rec.self != 4 {
                        Spacer()
                    }
                }
            }

        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        CropView(crop: .circle, image: UIImage(named: "Image")) {
            _, _ in
        }
    }
}
