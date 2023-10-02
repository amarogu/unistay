//
//  MenuView.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/08/23.
//

import SwiftUI


func menuTitle(title: String, icon: String) -> some View {
    return HStack(alignment: .center) {
        Text(title).customStyle(type: "Semibold", size: 20)
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

struct MenuItemData: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
    var titleIcon: String
    var descIcon: String
    var options: [String]
    var selectedItem: Int
    var sheetTitle: String?
    var sheetFields: [String]?
    var sheetStates: [String]?
    var action: String?
    var sheetDescription: String?
    var singleAction: Bool
}

struct MenuView: View {
    var size: CGFloat
    var tabSize: CGFloat
    @Binding var isLoggedIn: Bool
    @State var generalMenu: [MenuItemData] = [.init(title: "Log out", titleIcon: "door.left.hand.open", descIcon: "", options: ["Click here to log out"], selectedItem: 0, singleAction: true), .init(title: "Password", titleIcon: "ellipsis.rectangle", descIcon: "pencil.line", options: ["Change your password"], selectedItem: 0, sheetTitle: "Changing your password", sheetFields: ["Current password", "New password", "Confirm new password"], sheetStates: ["", "", ""], action: "Change your password", singleAction: false), .init(title: "Theme", titleIcon: "moon.circle", descIcon: "chevron.down", options: ["System theme", "Light", "Dark"], selectedItem: 0, singleAction: false), .init(title: "Two-factor authentication", titleIcon: "lock.shield", descIcon: "chevron.down", options: ["Disabled", "Enabled"], selectedItem: 0, singleAction: false), .init(title: "Language", titleIcon: "globe", descIcon: "chevron.down", options: ["System language", "English", "Portuguese", "French"], selectedItem: 0, singleAction: false)]
    @State var accountMenu: [MenuItemData] = [.init(title: "Deletion", titleIcon: "delete.backward", descIcon: "hand.tap", options: ["Click here to delete your account"], selectedItem: 0, sheetTitle: "Deleting your account", action: "Click here to permanently delete your account", sheetDescription: "By clicking the below button you are making an irreversable action.", singleAction: false), .init(title: "Reset all preferences", titleIcon: "clock.arrow.circlepath", descIcon: "hand.tap", options: ["Click here to reset all your preferences"], selectedItem: 0, sheetTitle: "Resetting all your preferences", action: "Click here to reset all your preferences", sheetDescription: "By clicking the below button you will reset all of your preferences.", singleAction: false), .init(title: "Preferred currency", titleIcon: "dollarsign.circle", descIcon: "chevron.down", options: ["USD", "BRL", "EUR", "GBP"], selectedItem: 0, singleAction: false)]
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        menuTitle(title: "General settings", icon: "gear")
                        ForEach($generalMenu) { menu in
                            MenuItem(menuItemData: menu, isLoggedIn: $isLoggedIn)
                        }
                        Spacer()
                    }.padding(.bottom, 25).padding(.top, 10)
                    VStack(alignment: .leading) {
                        menuTitle(title: "Account settings", icon: "person.2.badge.gearshape")
                        ForEach($accountMenu) {
                            menu in
                            MenuItem(menuItemData: menu, isLoggedIn: $isLoggedIn)
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
