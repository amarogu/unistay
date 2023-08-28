//
//  TestLaunchView.swift
//  unistay
//
//  Created by Gustavo Amaro on 24/08/23.
//

import SwiftUI




struct TestLaunchView: View {
    
    @State private var text: [String] = ["", ""]
    var fields: [String] = ["E-mail address", "Password"]
    var icons: [String] = ["envelope", "key"]
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    //@State private var responseData = "a"
    
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            AuthForm(text: $text, fields: fields, icons: icons, width: width, title: "Log In", links: ["Forgot your password?", "Create an account"], linkIcons: ["questionmark.circle", "person.crop.circle.badge.plus"], destinations: [AnyView(ForgotYourPassword()), AnyView(SignUpView())], action: {""})
            
        }
        
    }
    
    
    struct TestLaunchView_Previews: PreviewProvider {
        static var previews: some View {
            TestLaunchView()
        }
    }
}
