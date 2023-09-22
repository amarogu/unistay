//
//  ForgotYourPassword.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI

struct ForgotYourPassword: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                styledText(type: "Regular", size: 14, content: "Content")
            }
        }
    }
}

struct ForgotYourPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotYourPassword()
    }
}
