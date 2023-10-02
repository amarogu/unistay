//
//  FormHeader.swift
//  unistay
//
//  Created by Gustavo Amaro on 16/09/23.
//

import SwiftUI
import Combine

struct FormHeader: View {
    @State var alert: Bool = false
    @State var selectedLanguageIndex = 0
    @State var selectedBtnIndex = 0
    let languages = ["en", "pt", "fr"]
    let explanations = [
        "The selected language is controlled by the system. To change it, please change the selected language in settings.",
        "O idioma selecionado é controlado pelo sistema. Para alterá-lo, altere o idioma selecionado nas configurações.",
        "La langue sélectionnée est contrôlée par le système. Pour le modifier, veuillez modifier la langue sélectionnée dans les paramètres."
    ]
    let doneButton = [
        "Done",
        "Fechar",
        "Fermer"
    ]

    var body: some View {
        HStack {
            Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 24)
            Text("UniStay").customStyle(type: "Bold", size: 22)
        }.padding(.bottom, -10)
        HStack {
            Text("Sign up").customStyle(type: "Bold", size: 34)
            Spacer()
            Button(action: {
                alert.toggle()
                timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
                timerCancellable = timer.sink { _ in
                    selectedLanguageIndex = (selectedLanguageIndex + 1) % languages.count
                    selectedBtnIndex = (selectedBtnIndex + 1) % doneButton.count
                }
            }) {
                HStack {
                    Image(systemName: "globe").foregroundColor(Color("Body"))
                    Text(Locale.current.language.languageCode?.identifier.uppercased() ?? "").customStyle(size: 14)
                }
            }
        }.sheet(isPresented: $alert, onDismiss: {
            // Stop the timer when the sheet is dismissed
            timer.upstream.connect().cancel()
        }) {
            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    Button(action: {
                        alert = false
                    }) {
                        ZStack {
                            ForEach(0..<doneButton.count) {
                                index in
                                Text(doneButton[index]).customStyle(type: "Semibold", size: 14).opacity(selectedBtnIndex == index ? 1.0 : 0.0).animation(.easeInOut(duration: 1.0), value: selectedBtnIndex)
                            }
                        }
                    }
                }.padding(.bottom, 18)
                ZStack {
                    ForEach(0..<languages.count) { index in
                        Text(explanations[index]).customStyle(size: 14).opacity(selectedLanguageIndex == index ? 1.0 : 0.0).animation(.easeInOut(duration: 1.0), value: selectedLanguageIndex)
                    }
                }
                
            }.padding(28).presentationDetents([.fraction(0.3)])
        }
    }

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timerCancellable: AnyCancellable? = nil
}

