//
//  LoginView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/08/23.
//

import SwiftUI



struct LoginView: View {
    @State var loginInputs: [[String]] = [["", ""]]
    var loginFields: [[String]] = [["E-mail address", "Password"]]
    var loginIcons: [[String]] = [["envelope", "key"]]
    @State var step: Int = 0
    @StateObject var viewModel = LoginViewModel()
    //var errorVar: any Error
    func validateLogin() -> String {
        
        let email = loginInputs[0][0]
        let password = loginInputs[0][1]
        if email.count < 5 || email.count > 50 || !email.contains("@") {
            return "The e-mail address must contain '@'and be at least 5 characters long"
        }
        if password.count < 8 {
            return "The password does not contain the minimun amount of characters"
        }
        if step == 1 {
            return ""
        }
        //step += 1
        return ""
    }
    @Binding var isLoggedIn: Bool
    @State var isToggleOn: Bool = false
    //@State var serverResponse: String = "AA"
    var body: some View {
        Text("h")
    }
        //Text("Hello")
    }
    
