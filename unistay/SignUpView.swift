//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI

func signUp() {
    // Prepare the JSON data
    let json: [String: Any] = ["user": ["username": "helnhaaaalo",
                                        "email": "ahjh@aaaaaaa",
                                        "language": "English",
                                        "accountType": "normal",
                                        "password": "hyadhshjah7883792Juh",
                                        "private": true,
                                        "currency": "USD"] as [String : Any]]
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
   
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            
            Button(action: {
                signUp()
            }) {
                
            }
        }
    }
}


