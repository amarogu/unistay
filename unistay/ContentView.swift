//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

/*func styledText(type: String, size: CGFloat, content: String, color: String = "BodyEmphasized") -> Text {
    return Text(content).font(.custom("Eina03-\(type)", size: size)).foregroundColor(Color(color))
}

func localizedText(type: String, size: CGFloat, contentKey: LocalizedStringKey, color: String = "BodyEmphasized") -> Text {
    return Text(contentKey).font(.custom("Eina03-\(type)", size: size)).foregroundColor(Color(color))
}*/

struct CustomTextStyle: ViewModifier {
    var type: String
    var size: CGFloat
    var color: String

    func body(content: Content) -> some View {
        content
            .font(.custom("Eina03-\(type)", size: size))
            .foregroundColor(Color(color))
    }
}

extension Text {
    func customStyle(type: String = "Regular", size: CGFloat, color: String = "BodyEmphasized") -> some View {
        self.modifier(CustomTextStyle(type: type, size: size, color: color))
    }
}



/*struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
 /Users/gustavoamaro/Documents/GitHub/unistay/unistay/ViewModels if text.isEmpty { placeholder }
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
    var model: SignUpViewModel = SignUpViewModel()
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
                    UserPanel(tabSize: tabSize)
                }
                HStack(alignment: .bottom) {
                    ForEach(views, id:\.self) {
                        option in
                        unistay.tabItem(selectedTab: $selectedTab, option: option)
                    }
                }.padding(.bottom, 38).padding(.top, 58).background(GeometryReader {
                    geo in
                    LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.62), endPoint: .top).onAppear {
                        tabSize = geo.size.height
                        //sizeCompute(size: tabSize)
                    }
                })
            }.frame(maxHeight: .infinity).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(true).padding(.horizontal, 18).padding(.top, 14).padding(.bottom, 0)
        }.background(Color("BackgroundColor"))
        
    }
}
    
