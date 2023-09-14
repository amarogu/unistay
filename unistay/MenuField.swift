//
//  MenuField.swift
//  unistay
//
//  Created by Gustavo Amaro on 14/09/23.
//

import SwiftUI

struct MenuField: View {
    var items: [String]
    @State var menuSelection: String
    var icon: String
    var placeholder: Text

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
                placeholder
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 14)).foregroundColor(Color("BodyEmphasized"))
            }
        }
    }
}

