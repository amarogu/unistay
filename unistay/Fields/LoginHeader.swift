//
//  loginHeader.swift
//  unistay
//
//  Created by Gustavo Amaro on 18/09/23.
//

import SwiftUI

struct LoginHeader: View {
    let languageCode = Locale.current.identifier 
    let regionCode = Locale.current.region?.identifier ?? ""
    var languages: [String] = ["System language", "English", "Portuguese", "French"]
    @State var locIdentifier: String = "en"
    @State var selectedLanguage: String = "System language"
    var body: some View {
        HStack {
            Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 24)
            styledText(type: "Bold", size: 22, content: "UniStay")
        }.padding(.bottom, -10)
        HStack {
            styledText(type: "Bold", size: 34, content: "Login")
            Spacer()
            Menu {
                ForEach(languages, id: \.self) {
                    language in
                    Button(action: {
                        let languageId = "\(languageCode)-\(regionCode)"
                        selectedLanguage = language
                        switch selectedLanguage {
                        case "System language":
                            locIdentifier = languageId
                            break
                        case "English":
                            locIdentifier = "en"
                            break
                        case "Portuguese":
                            locIdentifier = "pt-br"
                            break
                        case "French":
                            locIdentifier = "fr"
                            break
                        default:
                            break
                        }
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
