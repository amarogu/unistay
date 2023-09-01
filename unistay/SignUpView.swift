//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI

func signUp(inputs: [[String]]) {
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


struct SignUpView: View {
    //@Binding var responseData: String
    @State var signupInputs: [[String]] = [["", "", "", "", ""], ["", ""], ["", ""]]
    var signupFields: [[String]] = [["Username", "E-mail address", "Confirm your e-mail address", "Password", "Confirm your password"], ["Upload a profile picture", "Insert a user bio"], ["Preferred locations", "Preferred currency"]]
    @State var signupIcons: [[String]] = [["person.crop.circle", "envelope", "checkmark.circle", "key", "checkmark.circle"], ["camera.circle", "bubble.right.circle"], ["location.circle", "dollarsign.circle"]]
    @State var step: Int = 0
    func validateSignUp() -> String {
        switch step {
        case 0:
            let username = signupInputs[0][0]
            let email = signupInputs[0][1]
            let emailConfirm = signupInputs[0][2]
            let password = signupInputs[0][3]
            let passwordConfirm = signupInputs[0][4]
            if username.count < 3 || username.count > 20 {
                return "The username needs to be 3 to 20 characters long"
            }
            if email != emailConfirm {
                return "The e-mail addresses do not match"
            }
            if password != passwordConfirm {
                return "The passwords do not match"
            }
            if email.count < 5 || email.count > 50 || !email.contains("@") {
                return "The e-mail address is not valid"
            }
            if password.count < 8 || password.count > 50 {
                return "The password does not fit the criteria"
            }
        case 1:
            let bio = signupInputs[1][1]
            if bio.isEmpty || bio.count > 325 {
                return "Please insert a valid bio"
            }
        case 2:
            let preferredLocations = signupFields[2][0]
            let preferredCurrency = signupFields[2][1]
            if preferredLocations.isEmpty {
                return "Please insert at least one location"
            }
            if preferredCurrency.isEmpty {
                return "Please insert at least one currency"
            }
        default: return "Internal error"
        }
        step += 1
        return ""
    }
    
    var body: some View {
       
        Step(inputs: $signupInputs, fields: signupFields, icons: signupIcons, currentStep: $step, validate: validateSignUp, error: "", call: {signUp(inputs: signupInputs)}, links: false, title: "Sign up").onChange(of: signupInputs, perform: {
            newValue in
            if (signupInputs[0][1] == signupInputs[0][2] && !signupInputs[0][1].isEmpty) {
                signupIcons[0][2] = "checkmark.circle.fill"
            } else {
                signupIcons[0][2] = "checkmark.circle"
            }
        })
        
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


