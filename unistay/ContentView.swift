//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

func styledText(type: String, size: CGFloat, content: String) -> Text {
    return Text(content).font(.custom("Eina03-\(type)", size: size))
}

/*struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}*/



struct ContentView: View {
    @State private var searchText = ""
    // @State private var searchText3 = "a"
    @State var text: String = ""
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                styledText(type: "Bold", size: 30, content: "Accommodations")
                Spacer()
                Image(systemName: "line.3.horizontal.decrease").font(.system(size: 24))
            }
            Spacer()
            /*SearchBar(searchText: $searchText).padding(.all, 10).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("SearchBar")/*@END_MENU_TOKEN@*/).cornerRadius(5)*/
            SearchBar(
                placeholder: Text("Search accommodations, locations...").foregroundColor(Color(UIColor(named: "BodyEmphasized")!)).font(.custom("Eina03-Regular", size: 13)),
                text: $text
            ).padding(.vertical, 10).padding(.horizontal, 20).background(Color("SearchBar")).cornerRadius(5)
                
            
        }.padding(16.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Color")/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
