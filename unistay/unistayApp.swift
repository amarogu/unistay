//
//  unistayApp.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

@main
struct unistayApp: App {
    @State var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                            ContentView()
                        } else {
                            LoginView(isLoggedIn: $isLoggedIn)
                        }
        }
    }
}
