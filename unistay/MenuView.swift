//
//  MenuView.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/08/23.
//

import SwiftUI


func menuTitle(title: String, icon: String) -> some View {
    return HStack(alignment: .center) {
        styledText(type: "SemiBold", size: 20, content: title)
        Image(systemName: icon)
    }.padding(.bottom, 25)
}

func menuItem(title: String, desc: String, titleIcon: String, descIcon: String, options: Array<String>, selecedtedItem: Binding<String>) -> some View {
    return VStack(alignment: .leading) {
        HStack(alignment: .center) {
            styledText(type: "Regular", size: 16, content: title)
            Image(systemName: titleIcon)
        }.padding(.bottom, 10)
        HStack(alignment: .center) {
            styledText(type: "Regular", size: 16, content: desc).foregroundColor(Color("Body")).underline()
            if (options == []) {
                Image(systemName: descIcon).foregroundColor(Color("Body"))
            } else {
                Menu {
                    ForEach(options, id: \.self) {
                        option in
                        Button(action: {
                            // if (selecte)
                        }) {
                            Label(option, systemImage: "")
                        }
                    }
                }
            }
        }
    }.padding(.bottom, 45)
}

struct MenuView: View {
    @State private var password: String = ""
    @State private var themeIndex: Int = 0
    @State private var twoFAEnabled: Bool = false
    var size: CGFloat
    var tabSize: CGFloat
    @State private var selectedItem: String
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        menuTitle(title: "General settings", icon: "gear")
                        menuItem(title: "Password", desc: "Change your password", titleIcon: "ellipsis.rectangle", descIcon: "pencil.line")
                        menuItem(title: "Theme", desc: "Change your password", titleIcon: "moon.circle", descIcon: "chevron.down")
                        menuItem(title: "Password", desc: "Change your password", titleIcon: "ellipsis.rectangle", descIcon: "chevron.down")
                        Spacer()
                    }.padding(.bottom, 25).padding(.top, 10)
                    VStack(alignment: .leading) {
                        menuTitle(title: "Account settings", icon: "person.2.badge.gearshape")
                        menuItem(title: "Deletion", desc: "Click here to delete your account", titleIcon: "delete.backward", descIcon: "hand.tap")
                        menuItem(title: "Reset all preferences", desc: "Click here to reset all your preferences", titleIcon: "clock.arrow.circlepath", descIcon: "hand.tap")
                        menuItem(title: "Preferred currency", desc: "USD", titleIcon: "dollarsign.circle", descIcon: "chevron.down")
                        Spacer()
                    }//.padding(.bottom, 25)
                }
                Spacer()
            }.padding(.horizontal, size <= 400 ? 3 + 12 : 8 + 12).padding(.bottom, tabSize)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("BackgroundColor"))
    }
}

/*struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}*/
