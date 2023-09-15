//
//  FieldType.swift
//  unistay
//
//  Created by Gustavo Amaro on 15/09/23.
//

import SwiftUI

enum FieldType {
    case text(Binding<String>, Text, String)
    case emptyImg(Binding<Bool>, Binding<UIImage?>)
    case selectedImg(Binding<Bool>, Binding<UIImage?>)
    case menu([String], String, String, Text)
}

extension FieldType {
    func renderField() -> AnyView {
        switch self {
        case .text(let binding, let placeholder, let icon):
            return AnyView(TextInputField(text: binding, placeholder: placeholder, icon: icon))
        case .emptyImg(let presented, let croppedImage):
            return AnyView(EmptyPicField(presented: presented, croppedImage: croppedImage))
        case .selectedImg(let presented, let croppedImage):
            return AnyView(SelectedPicField(presented: presented, croppedImage: croppedImage))
        case .menu(let items, let menuSelection, let icon, let placeholder):
            return AnyView(MenuField(items: items, menuSelection: menuSelection, icon: icon, placeholder: placeholder))
        }
    }
}
