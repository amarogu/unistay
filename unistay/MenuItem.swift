//
//  MenuItem.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/08/23.
//

import SwiftUI

struct MenuItem: View {
    @Binding var menuItemData: MenuItemData
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                styledText(type: "Regular", size: 16, content: menuItemData.title)
                Image(systemName: menuItemData.titleIcon)
            }.padding(.bottom, 10)
            HStack(alignment: .center) {
                styledText(type: "Regular", size: 16, content: menuItemData.options[menuItemData.selectedItem]).foregroundColor(Color("Body")).underline()
                if (menuItemData.options.count == 1) {
                    Image(systemName: menuItemData.descIcon).foregroundColor(Color("Body"))
                } else {
                    Menu {
                        ForEach(menuItemData.options, id: \.self) {
                            option in
                            Button(action: {
                                menuItemData.selectedItem = menuItemData.options.firstIndex(of: option)!
                            }) {
                                Label(option, systemImage: menuItemData.selectedItem == menuItemData.options.firstIndex(of: option)! ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: menuItemData.descIcon).foregroundColor(Color("Body"))
                    }
                }
            }
        }.padding(.bottom, 45)
    }
}

/*struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem()
    }
}*/
