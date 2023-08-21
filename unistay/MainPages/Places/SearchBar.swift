//
//  SearchBar.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/08/23.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").font(.system(size: 12))
            ZStack(alignment: .leading) {
                if text.isEmpty { placeholder }
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).font(.custom("Eina03-Regular", size: 13))
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
