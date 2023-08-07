//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

func styledText(type: String, size: CGFloat, content: String) -> Text {
    return Text(content).font(.custom("Eina03-\(type)", size: size))
}

/*struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}*/

func icon(name: String, size: CGFloat) -> some View {
    return Image(systemName: name).resizable().aspectRatio(contentMode: .fit).frame(width: size)
}

struct ContentView: View {
    @State private var searchText = ""
    // @State private var searchText3 = "a"
    @State var text: String = ""
    @State private var selectedFilters: [String] = []
    var filterOptions = ["option", "option 1", "option 2", "option 3"]
    @State private var isMenuOpen = false
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    enum Tab {
        case home, chat, profile, menu
    }
    @State private var selectedTab: Tab = .home
    var views = ["Places", "Chats", "Profile", "Menu"]
    
    var body: some View {
        VStack(alignment: .center) {
            Places()
            HStack(alignment: .bottom) {
                ForEach(views, id:\.self) {
                    option in
                    VStack(alignment: .center) {
                        if (option == "Places") {
                            icon(name: "house", size: 22)
                        } else if (option == "Chats") {
                            icon(name: "bubble.left.and.bubble.right", size: 22)
                        } else if (option == "Profile") {
                            icon(name: "person.crop.circle", size: 22)
                        } else {
                            icon(name: "line.3.horizontal", size: 22)
                        }
                        styledText(type: "Regular", size: 14, content: option)
                        
                    }.frame(maxWidth: .infinity)
                }
            }
        }
        
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }}
