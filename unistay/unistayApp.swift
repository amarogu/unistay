//
//  unistayApp.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/07/23.
//

import SwiftUI

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private let isLoggedInKey = "isLoggedIn"
    
    var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: isLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
        }
    }
    
    private init() {}
}

@main
struct unistayApp: App {
    @State var isLoggedIn: Bool = SessionManager.shared.isLoggedIn
    var body: some Scene {
        /*WindowGroup {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn)
                        } else {
                            //LoginView(isLoggedIn: $isLoggedIn)
                        }
        }*/
        WindowGroup {
            Login(isLoggedIn: $isLoggedIn)
        }
    }
}

struct AppProvider_Previews: PreviewProvider {
    static var previews: some View {
        @State var isLoggedIn = false
        Login(isLoggedIn: $isLoggedIn)
    }
}
