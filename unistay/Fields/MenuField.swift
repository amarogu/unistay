//
//  MenuField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct MenuField: View {
    var items: [String]
    @Binding var menuSelection: String
    var icon: String
    var placeholder: String

    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    menuSelection = item
                }) {
                    Label(item, systemImage: menuSelection == item ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                Image(systemName: icon).font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
                Text(placeholder).customStyle(size: 13)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
            }.padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
        }
    }
}

