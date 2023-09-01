//
//  LoginView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/08/23.
//

import SwiftUI

func login(inputs: [[String]]) {
    // Prepare the JSON data
    let json: [String: Any] = ["user": ["username": inputs[0][0],
                                        "email": inputs[0][1],
                                        "language": "English",
                                        "accountType": "normal",
                                        "password": inputs[0][3],
                                        "private": true,
                                        "currency": inputs[2][1],
                                        "preferredLocations": inputs[2][0]] as [String : Any]]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    // Create the request
    let url = URL(string: "http://localhost:3000/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
    }
    task.resume()
}


struct LoginView: View {
    @State var loginInputs: [[String]] = [["", ""]]
    var loginFields: [[String]] = [["E-mail address", "Password"]]
    var loginIcons: [[String]] = [["envelope", "key"]]
    @State var step: Int = 0
    func validateLogin() -> String {
        step += 1
        return ""
    }
    var body: some View {
        Step(inputs: $loginInputs, fields: loginFields, icons: loginIcons, currentStep: $step, validate: validateLogin, error: "", call: {}, links: true, title: "Log in")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
