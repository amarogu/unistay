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

class Global: ObservableObject {
    @Published var navTag: String? = ""
}

func checkCookies() -> Text {
    if let cookies = HTTPCookieStorage.shared.cookies {
        for cookie in cookies {
            print("Name: \(cookie.name), Value: \(cookie.value), Domain: \(cookie.domain), Path: \(cookie.path)")
            return Text("\(cookie.value)")
        }
    } else {
        print("No cookies found")
    }
    return Text("\thanks")
}

@main
struct unistayApp: App {
    @State var isLoggedIn: Bool = SessionManager.shared.isLoggedIn
    @State var navigateToContent: Bool = false
    var body: some Scene {
        /*WindowGroup {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn)
                        } else {
                            //LoginView(isLoggedIn: $isLoggedIn)
                        }
        }*/
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    Login(isLoggedIn: $isLoggedIn)
                }
            }
        }
    }
}

struct AppProvider_Previews: PreviewProvider {
    static var previews: some View {
        @State var isLoggedIn = false
        NavigationStack {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn)
            } else {
                Login(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
