//
//  Suggestion.swift
//  unistay
//
//  Created by Gustavo Amaro on 21/08/23.
//

import SwiftUI

struct SuggestionData {
    var id: UUID = UUID()
    var title: String
    var content: String
}



struct Suggestion: View {
    var width: CGFloat
    @State var iconSize: CGFloat = 0
    
    var suggestion: SuggestionData = .init(title: "Set up your uni preferences", content: "Click here to set up your uni preferences. You can take a quick quiz or search for the unis yourself.")
   
    
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 14) {
                Text(suggestion.title).customStyle(type: "Semibold", size: 16)
                Text(suggestion.content).customStyle(size: 14).padding(.trailing, width * 0.08)
            }/*.background(GeometryReader {
                geo in
                Color.clear.onAppear {
                    contentSize = [geo.size.width, geo.size.height]
                }
            })*/
            Image(systemName: "graduationcap").resizable().aspectRatio(contentMode: .fit).frame(width: width * 0.1).foregroundColor(.white).padding(.all, width * 0.09).background(GeometryReader {
                geo in
                LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing).onAppear {
                    iconSize = geo.size.width
                }
            }).cornerRadius(15)
        }.frame(maxWidth: .infinity).padding(.all, 20).background(Color("Gray")).cornerRadius(15)
    }
}

struct Suggestion_Previews: PreviewProvider {
    static var previews: some View {
        Suggestion(width: 400)
    }
}
