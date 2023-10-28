//
//  SearchBar.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/08/23.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").font(.system(size: 12))
            ZStack(alignment: .leading) {
                if text.isEmpty { Text(placeholder).customStyle(size: 14) }
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13))//.position(x: 1, y: 1)
            }
        }
    }
    
}

/*struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack() {
            Image(systemName: "magnifyingglass")
            TextField("Search accommodations, locations...", text: $searchText)
            }
    }
    
    
}*/
