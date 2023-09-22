//
//  SwiftUIView.swift
//  unistay
//
//  Created by Gustavo Amaro on 05/09/23.
//

import SwiftUI
import Combine

struct PublisherSignUp: View {
    @State var signupInputs: [[String]] = [["", "", "", "", ""], ["", ""], ["", ""], ["", "", "", "", "", "", "", ""], ["", "", ""]]
       var signupFields: [[String]] = [["Username", "E-mail address", "Confirm your e-mail address", "Password", "Confirm your password"], ["Upload a profile picture", "Insert your publisher bio"], ["Your location", "Currency"], ["Publication title", "Publication description", "Rent", "Currency", "Type"], ["Publication visibility", "Publication location", "Publication images"]]
       @State var signupIcons: [[String]] = [["person.crop.circle", "envelope", "checkmark.circle", "key", "checkmark.circle"], ["camera.circle", "bubble.right.circle"], ["location.circle", "dollarsign.circle"], ["book.circle", "text.justify", "bitcoinsign.circle", "dollarsign.circle", "circle.dashed"], ["eye.circle", "location.circle", "camera.circle.fill"]]
       @State var step: Int = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
