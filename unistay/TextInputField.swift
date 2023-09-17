//
//  TextInputField.swift
//  unistay
//
//  Created by Gustavo Amaro on 17/09/23.
//

import SwiftUI

struct TextInputField: View {
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    @FocusState private var isFocused: Bool
    
    @Binding var input: String
    var placeholderText: String
    var placeholderIcon: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: placeholderIcon).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                ZStack(alignment: .topLeading) {
                    if input.isEmpty { styledText(type: "Regular", size: 13, content: placeholderText) }
                    TextField(text: $input, axis: .vertical, label: {}).font(.custom("Eina03-Regular", size: 13)).foregroundColor(Color("BodyEmphasized"))
                }
            }
        }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5).padding(.vertical, 1).frame(maxWidth: .infinity).onTapGesture {
            isFocused = true
        }

    }
}
