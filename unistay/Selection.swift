//
//  Selection.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct Selection: View {
    var viewOptions = ["Recommended", "Saved", "Connected"]
    @State private var selectedView: String = "Recommended"
    var body: some View {
        HStack() {
            ForEach(viewOptions, id: \.self) {
                option in
                Button(action: {
                    selectedView = option
                }, label: {
                    styledText(type: "Semibold", size: 18, content: option).foregroundColor(selectedView == option ? Color("BodyEmphasized") : Color("BodyEmphasized").opacity(0.7))
                }).padding(.trailing, 12)
            }
            Spacer()
        }
        
    }
    
    struct Selection_Previews: PreviewProvider {
        static var previews: some View {
            Selection()
        }
    }
}
