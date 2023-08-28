//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI

func signUp(userInsertedContent: [String: [String: String]]) -> Void {
    // Prepare the JSON data
    let json: [String: Any] = ["user": [
            "username": userInsertedContent["AuthData"]!["username"]!,
            "email": userInsertedContent["AuthData"]!["email"]!,
            "password": userInsertedContent["AuthData"]!["password"]!,
            "profilePic": userInsertedContent["UserInfo"]!["profilePicture"]!,
            "bio": userInsertedContent["UserInfo"]!["bio"]!,
            "preferredLocations": userInsertedContent["Preferences"]!["locations"]!,
            "preferredCurrency": userInsertedContent["Preferences"]!["currency"]!,
            "language": "English",
            "accountType": "normal",
            "private": true,
            "currency": "USD"
    ] as [String : Any]]
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
    //@State private var text: [[String]] = [["", "", "", "", ""], ["", ""], ["", ""]]
    @State private var userInsertedContent: [String: [String: String]] = [
        "AuthData": [
            "username": "",
            "email": "",
            "emailVerification": "",
            "password": "",
            "passwordVerification": ""
        ],
        "UserInfo": [
            "profilePicture": "",
            "bio": ""
        ],
        "Preferences": [
            "locations": "",
            "currency": ""
        ]
    ]
    var fields: [String: [String]] = [
        "AuthData": ["Username", "E-mail address", "Confirm your e-mail adress", "Create a password", "Confirm your new password"],
        "UserInfo": ["Upload a profile picture", "Insert a user bio"],
        "Preferences": ["Preferred locations", "Preferred currency"]
    ]

    var icons: [String: [String]] = [
        "AuthData": ["person.circle", "envelope", "checkmark.circle", "key", "checkmark.circle"],
        "UserInfo": ["person.circle", "camera", "bubble.circle"],
        "Preferences": ["location.circle", "dollarsign.circle"]
    ]
    /*var fields: [[String]] = [["Username", "E-mail address", "Confirm your e-mail adress", "Create a password", "Confirm your new password"], ["Upload a profile picture", "Insert a user bio"], ["Preferred locations", "Preferred currency"]]
    var icons: [[String]] = [["person.circle", "envelope", "checkmark.circle", "key", "checkmark.circle"], ["person.circle", "camera", "bubble.circle"], ["location.circle", "dollarsign.circle"]]*/
    var links: [String] = []
    @State var titleHeight: CGFloat = 0
    @State var subtitleHeight: CGFloat = 0
    @State private var errorMessage: String = ""
    @State private var step: Int = 0
    func validateInputs() {
        //let userInput = text[step]
            switch step {
            case 0: // Step 1 Validation
                let username = userInsertedContent["AuthData"]!["username"]!
                let email = userInsertedContent["AuthData"]!["email"]!
                let password = userInsertedContent["AuthData"]!["password"]!
                let emailVerification = userInsertedContent["AuthData"]!["emailVerification"]!
                let passwordVerification = userInsertedContent["AuthData"]!["passwordVerification"]!

                        // Validate username
                        if username.count < 3 || username.count > 20 {
                            errorMessage = "The username needs to be 3 to 20 characters long"
                            return
                        }

                        // Validate email
                        if email.count < 5 || email.count > 50 || !email.contains("@") {
                            errorMessage = "The email needs to be 5 to 50 characters long and contain a '@'"
                            return
                        }

                        // Validate password
                        if password.count < 8 || password.count > 50 {
                            errorMessage = "The password needs to be 8 to 50 characters long"
                            return
                        }
                
                if password != passwordVerification {
                    errorMessage = "The passwords do not match."
                    return
                }
                
                if email != emailVerification {
                    errorMessage = "The e-mail addresses do not match."
                    return
                }
            case 1: // Step 2 Validation
                //let profilePicture = userInsertedContent["UserInfo"]!["profilePicture"]!
                let bio = userInsertedContent["UserInfo"]!["bio"]!
                        // Validate profile pic is present
                        if bio.isEmpty {
                            errorMessage = "Please insert a bio."
                            return
                        }
            case 2:
                let preferredLocation = userInsertedContent["Preferences"]!["locations"]!
                let preferredCurrency = userInsertedContent["Preferences"]!["currency"]!
                if preferredLocation.isEmpty {
                    errorMessage = "Seelect at least one location to continue."
                }
                if preferredCurrency.isEmpty {
                    errorMessage = "Select a preferred currency."
                }
                signUp(userInsertedContent: userInsertedContent)
            default: return
            }

            // If you reach here, that means validation was successful, so increment the step
            step += 1
        }
    
    var body: some View {
        GeometryReader {
            geo in
            let width = geo.size.width
            
            AuthForm(text: $text, fields: fields, icons: icons, width: width, title: "Sign Up", links: links, action: , step: step)
            
        }
    }
}


