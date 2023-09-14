//
//  SelectedPicField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct SelectedPicField: View {
    @Binding var presented: Bool
    @Binding var croppedImage: UIImage?

    var body: some View {
        Button(action: {
            presented.toggle()
        }) {
            if let image = croppedImage {
                Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40)
            } else {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 14))
                    styledText(type: "Regular", size: 13, content: "Click here to insert a profile picture")
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
            }
        }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
    }
}
