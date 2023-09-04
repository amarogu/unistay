//
//  LoginView.swift
//  unistay
//
//  Created by Gustavo Amaro on 29/08/23.
//

import SwiftUI

struct ServerResponse: Codable {
    let message: String
}

import Combine

class LoginViewModel: ObservableObject {
    @Published var serverResponse: String = ""
    var cancellables = Set<AnyCancellable>()

    func login(email: String, password: String) {
        let url = URL(string: "http://192.168.1.17:3000/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        request.httpBody = jsonData

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 401 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ServerResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.serverResponse = response.message
            })
            .store(in: &cancellables)
    }
}


/*func login(inputs: [[String]]) {
    // Prepare the JSON data
    let json: [String: Any] = ["email": inputs[0][0], "password": inputs[0][1]]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    // Create the request
    let url = URL(string: "http://localhost:3000/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
    }
    task.resume()
}*/



struct LoginView: View {
    @State var loginInputs: [[String]] = [["", ""], [""]]
    var loginFields: [[String]] = [["E-mail address", "Password"], [""]]
    var loginIcons: [[String]] = [["envelope", "key"], [""]]
    @State var step: Int = 0
    @StateObject private var viewModel = LoginViewModel()
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
        step += 1
        return ""
    }
    
    //@State var serverResponse: String = "AA"
    var body: some View {
        Step(inputs: $loginInputs, fields: loginFields, icons: loginIcons, currentStep: $step, validate: validateLogin, error: "", call: {viewModel.login(email: loginInputs[0][0], password: loginInputs[0][1])}, links: true, title: "Log in", postStep: 1, serverResponse: viewModel.serverResponse)
        //Text("Hello")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
