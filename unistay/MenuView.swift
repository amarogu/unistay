//
//  MenuView.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/08/23.
//

import SwiftUI

struct GeneralSettingsItem: Identifiable, Hashable {
    var id = UUID()
    let name: String
    
}

struct MenuView: View {
    var body: some View {
        let generalSettings: [GeneralSettingsItem] = [.init(name: "Password"), .init(name: "Theme"), .init(name: "Two-factor authentication")]
        NavigationView {
            List(generalSettings) {
                setting in
                NavigationLink(destination: {Text("heyheyhey")}) {
                    Text("hello")
                }
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    HStack(alignment: .center) {
                        styledText(type: "Regular", size: 16, content: "General settings").padding(.trailing, 3)
                        Image(systemName: "gear").resizable().aspectRatio(contentMode: .fit).frame(width: 20)
                    }
                }

            }
        }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
