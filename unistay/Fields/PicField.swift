//
//  SelectedPicField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct PicField: View {
    @State var presented: Bool = false
    @Binding var croppedImage: UIImage?
    var content: [String]
    var body: some View {
            Button(action: {
                presented.toggle()
            }) {
                if let image = croppedImage {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 40)
                } else {
                    HStack {
                        Image(systemName: content[1]).font(.system(size: 14))
                        Text(content[0]).customStyle(size: 13)
                        Spacer()
                    }.frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                }
            }.cropImagePicker(crop: .circle, show: $presented, croppedImage: $croppedImage)
    }
}
