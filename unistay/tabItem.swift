//
//  tabItem.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct tabItem: View {
    @Binding private var selectedTab: String
    var option: String
    init(selectedTab: Binding<String>, option: String) {
        self._selectedTab = selectedTab
        self.option = option
    }
    @State var isActive: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                selectedTab = option
                isActive.toggle()
            }) {
                VStack(spacing: 8) {
                    if (option == "Places") {
                        Image(systemName: "house").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    } else if (option == "Chats") {
                        Image(systemName: "bubble.left.and.bubble.right").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    } else if (option == "Profile") {
                        Image(systemName: "person.crop.circle").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    } else {
                        Image(systemName: "line.3.horizontal").resizable().aspectRatio(contentMode: .fit).frame(width: 22).tint(Color("BodyEmphasized"))
                    }
                    Text(option).customStyle(size: 14)
                }
            }.symbolEffect(.bounce.up.byLayer, value: isActive)
        }.frame(maxWidth: .infinity)
    }
}

