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
                Text("Content").customStyle(size: 14)
            }
        }
    }
}

struct ForgotYourPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotYourPassword()
    }
}
