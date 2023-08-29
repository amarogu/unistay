//
//  LaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 23/08/23.
//

import SwiftUI

struct Field: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var icon: String
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: icon).font(.system(size: 12))
                ZStack(alignment: .leading) {
                    if text.isEmpty { placeholder }
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13))
                }
            }

        }.frame(maxWidth: .infinity)
    }
}
