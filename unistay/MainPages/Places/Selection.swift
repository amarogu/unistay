//
//  Selection.swift
//  unistay
//
//  Created by Gustavo Amaro on 08/08/23.
//

import SwiftUI

struct Selection: View {
    var viewOptions: [String]
    var model: SignUpViewModel = SignUpViewModel()
    @Binding var selectedView: String
    var body: some View {
        HStack() {
            ForEach(viewOptions, id: \.self) {
                option in
                Button(action: {
                    selectedView = option
                }, label: {
                    Text(option).customStyle(type: "Semibold", size: 18, color: selectedView == option ? "BodyEmphasized" : "BodyEmphasized").opacity(0.7)
                }).padding(.trailing, 12)
            }
            Spacer()
        }
        
    }
    
    
}
