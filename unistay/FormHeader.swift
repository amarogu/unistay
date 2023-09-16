//
//  FormHeader.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/09/23.
//

import SwiftUI

struct FormHeader: View {
    var languages: [String] = ["System language", "English", "Portuguese", "French"]
    @State var selectedLanguage: String = "System Language"
    var body: some View {
        HStack {
            Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 24)
            styledText(type: "Bold", size: 22, content: "UniStay")
        }.padding(.bottom, -10)
        HStack {
            styledText(type: "Bold", size: 34, content: "Sign Up")
            Spacer()
            Menu {
                ForEach(languages, id: \.self) {
                    language in
                    Button(action: {
                        selectedLanguage = language
                    }) {
                        Label(language, systemImage: selectedLanguage == language ? "checkmark" : "")
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "globe").foregroundColor(Color("Body"))
                    Image(systemName: "chevron.down").foregroundColor(Color("Body"))
                }
            }
        }.padding(.bottom, 10)
    }
}
