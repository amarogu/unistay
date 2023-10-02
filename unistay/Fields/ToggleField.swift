//
//  ToggleField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct ToggleField: View {
    @Binding var isToggleOn: Bool
    var field: LocalizedStringKey

    var body: some View {
        Toggle(isOn: $isToggleOn) {
            HStack {
                Image(systemName: "arrow.up.doc")
                Text(field).customStyle(size: 13)
            }
        }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).onTapGesture {
            isToggleOn.toggle()
        }
    }
}
