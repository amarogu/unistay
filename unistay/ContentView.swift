//
//  ContentView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack() {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Color")/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
