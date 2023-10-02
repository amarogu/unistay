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
    var body: some View {
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
            Text(option).customStyle(size: 14)
            
        }.frame(maxWidth: .infinity).onTapGesture {
            selectedTab = option
        }
    }
}

