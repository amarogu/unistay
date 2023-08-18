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

/*func menuItem(title: String, titleIcon: String, descIcon: String, options: [String]) -> some View {
    @State var selectedItem = options[0]
    return VStack(alignment: .leading) {
        HStack(alignment: .center) {
            styledText(type: "Regular", size: 16, content: title)
            Image(systemName: titleIcon)
        }.padding(.bottom, 10)
        HStack(alignment: .center) {
            styledText(type: "Regular", size: 16, content: selectedItem).foregroundColor(Color("Body")).underline()
            if (options.count == 1) {
                Image(systemName: descIcon).foregroundColor(Color("Body"))
            } else {
                Menu {
                    ForEach(options, id: \.self) {
                        option in
                        Button(action: {
                            selectedItem = option
                        }) {
                            Label(option, systemImage: selectedItem == option ? "checkmark" : "")
                        }
                    }
                } label: {
                    Image(systemName: descIcon).foregroundColor(Color("Body"))
                }
            }
        }
    }.padding(.bottom, 45)
}*/

struct MenuItemData: Identifiable {
    var id: UUID = UUID()
    
    var title: String
    var titleIcon: String
    var descIcon: String
    var options: [String]
    var selectedItem: Int
}

struct MenuView: View {
    var size: CGFloat
    var tabSize: CGFloat
    @State var generalMenu: [MenuItemData] = [.init(title: "Password", titleIcon: "ellipsis.rectangle", descIcon: "pencil.line", options: ["Change your password"], selectedItem: 0), .init(title: "Theme", titleIcon: "moon.circle", descIcon: "chevron.down", options: ["System theme", "Light", "Dark"], selectedItem: 0), .init(title: "Two-factor authentication", titleIcon: "lock.shield", descIcon: "chevron.down", options: ["Disabled", "Enabled"], selectedItem: 0), .init(title: "Language", titleIcon: "globe", descIcon: "chevron.down", options: ["System language", "English", "Portuguese", "French"], selectedItem: 0)]
    @State var accountMenu: [MenuItemData] = [.init(title: "Deletion", titleIcon: "delete.backward", descIcon: "hand.tap", options: ["Click here to delete your account"], selectedItem: 0), .init(title: "Reset all preferences", titleIcon: "clock.arrow.circlepath", descIcon: "hand.tap", options: ["Click here to reset all your preferences"], selectedItem: 0), .init(title: "Preferred currency", titleIcon: "dollarsign.circle", descIcon: "chevron.down", options: ["USD", "BRL", "EUR", "GBP"], selectedItem: 0)]
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        menuTitle(title: "General settings", icon: "gear")
                        ForEach($generalMenu) { menu in
                            MenuItem(menuItemData: menu)
                        }
                        Spacer()
                    }.padding(.bottom, 25).padding(.top, 10)
                    VStack(alignment: .leading) {
                        menuTitle(title: "Account settings", icon: "person.2.badge.gearshape")
                        ForEach($accountMenu) {
                            menu in
                            MenuItem(menuItemData: menu)
                        }
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
