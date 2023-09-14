//
//  ToggleField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct ToggleField: View {
    @Binding var isToggleOn: Bool
    var field: String

    var body: some View {
        Toggle(isOn: $isToggleOn) {
            HStack {
                Image(systemName: "arrow.up.doc")
                styledText(type: "Regular", size: 13, content: field)
            }
        }.tint(.accentColor).padding(.vertical, 5).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.bottom, 4).onTapGesture {
            isToggleOn.toggle()
        }
    }
}
