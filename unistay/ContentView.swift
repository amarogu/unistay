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
    var views = ["Places", "Chats", "Profile", "Menu"]
    @State private var selectedTab = "Places"
    
    var body: some View {
        GeometryReader {
            geometry in
            let size = geometry.size.width
            VStack(alignment: .center) {
                if(selectedTab == "Places") {
                    Places(size: size)
                }
                HStack(alignment: .bottom) {
                    ForEach(views, id:\.self) {
                        option in
                        unistay.tabItem(selectedTab: $selectedTab, option: option)
                    }
                }
            }.frame(maxHeight: .infinity)
        }
        
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().previewDevice("iPhone 14 Plus")
            ContentView().previewDevice("iPhone SE (3rd generation)")
            ContentView()
                .previewDevice("iPad (10th generation)")
        }
    }}
