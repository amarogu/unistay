//
//  Selection.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct Selection: View {
    var viewOptions: [LocalizedStringKey]
    @Binding var selectedView: LocalizedStringKey
    var body: some View {
        HStack() {
                    ForEach(viewOptions.indices, id: \.self) { index in
                        let option = viewOptions[index]
                        Button(action: {
                            selectedView = option
                        }, label: {
                            Text(option).customStyle(type: "Semibold", size: 17, color: selectedView == option ? "BodyEmphasized" : "Body").opacity(selectedView == option ? 1 : 0.7)
                        }).padding(.trailing, 12)
                    }
                    Spacer()
                }
        
    }
    
    
}
