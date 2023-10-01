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
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
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
                            
                            showCropView.toggle()
                        })
                    }
                }
            }
        }.fullScreenCover(isPresented: $showCropView) {
            CropView(crop: crop, image: selectedImage) { croppedImage, status in
                if let croppedImage {
                    self.croppedImage = croppedImage
                }
            }
        }.onChange(of: showCropView) { newValue in
            guard newValue, let selectedImage = selectedImage else {
                return
            }
            self.selectedImage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectedImage = selectedImage
            }
        }
    }
}

struct CropView: View {
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    @Environment (\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    var body: some View {
        GeometryReader {
            geo in
            //let width = geo.size.width
            let height = geo.size.height
            VStack() {
                //Text("hey")
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "x.circle")
                    }.foregroundColor(Color("BodyEmphasized"))
                    Spacer()
                    localizedText(type: "Semibold", size: 14, contentKey: "Crop").foregroundColor(Color("BodyEmphasized"))
                    Spacer()
                    Button(action: {
                        let renderer = ImageRenderer(content: ImageView(true))
                        renderer.proposedSize = .init(crop.size())
                        if let image = renderer.uiImage {
                            onCrop(image, true)
                        } else {
                            onCrop(nil, false)
                        }
                        dismiss()
                    }) {
                        Image(systemName: "checkmark.circle")
                    }.foregroundColor(Color("BodyEmphasized"))
                }.frame(maxWidth: .infinity).padding(.vertical, height * 0.02).padding(.horizontal, 20).background(Color("BackgroundColor")).zIndex(10)
                ImageView().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor"))//.edgesIgnoringSafeArea(.all)
            }.background(Color("BackgroundColor"))
        }
    }
    
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            if let image {
                Image(uiImage: image).resizable().aspectRatio(contentMode: .fill).overlay(content: {
                    GeometryReader {
                        proxy in
                        let rect = proxy.frame(in: .named("CROPVIEW"))
                        
                        Color.clear.onChange(of: isInteracting) {
                            newValue in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if rect.minX > 0 {
                                    offset.width = (offset.width - rect.minX)
                                    haptics(.light)
                                }
                                if rect.minY > 0 {
                                    offset.height = (offset.height - rect.minY)
                                    haptics(.light)
                                }
                                if rect.maxX < size.width {
                                    offset.width = (rect.minX - offset.width)
                                    haptics(.light)
                                }
                                if rect.maxY < size.height {
                                    offset.height = (rect.minY - offset.height)
                                    haptics(.light)
                                }
                            }
                            if(!newValue) {
                                lastStoredOffset = offset
                            }
                        }
                    }
                }).frame(size)
            }
        }.scaleEffect(scale).offset(offset).overlay(content: {
            if !hideGrids {
                Grids()
            }
        }).coordinateSpace(name: "CROPVIEW").gesture(DragGesture().updating($isInteracting, body: {_, out, _ in
            out = true
        }).onChanged({
            value in
            let translation = value.translation
            offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
        })).gesture(MagnificationGesture().updating($isInteracting, body: {
            _, out, _ in
            out = true
        }).onChanged({
            value in
            let updatedScale = value + lastScale
            scale = (updatedScale < 1 ? 1 : updatedScale)
        }).onEnded({
            value in
            withAnimation(.easeOut(duration: 0.2)) {
                if scale < 1 {
                    scale = 1
                    lastScale = 0
                } else {
                    lastScale = scale - 1
                }
            }
        })).frame(cropSize).cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
    }
    
    @ViewBuilder
    func Grids() -> some View {
        
        ZStack {
            HStack {
                ForEach(1...4, id: \.self) {
                    rec in
                    Rectangle().fill(Color("White")).opacity(0.6).frame(maxWidth: rec.self == 1 || rec.self == 4 ? 0 : 1, maxHeight: .infinity)
                    if rec.self != 4 {
                        Spacer()
                    }
                }
            }
            VStack {
                ForEach(1...4, id: \.self) {
                    rec in
                    Rectangle().fill(Color("White")).opacity(0.6).frame(maxWidth: .infinity, maxHeight: rec.self == 1 || rec.self == 4 ? 0 : 1)
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
