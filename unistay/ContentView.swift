//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

func styledText(type: String, size: CGFloat, content: String, color: String = "BodyEmphasized") -> Text {
    return Text(content).font(.custom("Eina03-\(type)", size: size)).foregroundColor(Color(color))
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
    @State private var tabSize: CGFloat = 0
    @Binding var isLoggedIn: Bool
    var body: some View {
        GeometryReader {
            geometry in
            let size = geometry.size.width
            ZStack(alignment: .bottom) {
                if(selectedTab == "Places") {
                    Places(size: size, tabSize: tabSize)
                } else if (selectedTab == "Menu") {
                    MenuView(size: size, tabSize: tabSize, isLoggedIn: $isLoggedIn)
                } else if(selectedTab == "Profile") {
                    UserPanel()
                }
                HStack(alignment: .bottom) {
                    ForEach(views, id:\.self) {
                        option in
                        unistay.tabItem(selectedTab: $selectedTab, option: option)
                    }
                }.padding(.all, 18).background(GeometryReader {
                    geo in
                    LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.74), endPoint: .top).onAppear {
                        tabSize = geo.size.height
                        //sizeCompute(size: tabSize)
                    }
                })
            }.frame(maxHeight: .infinity).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(true)
        }.background(Color("BackgroundColor"))
        
    }
}
    
