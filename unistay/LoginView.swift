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
    @Published var serverResponse: String? = nil
        @Published var validationError: String = ""
        var cancellables = Set<AnyCancellable>()

        func login(email: String, password: String) {
            if !validateLogin(email: email, password: password) {
                return
            }

            let url = URL(string: "http://localhost:3000/login")!
            // remaining URLSession code...
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

        func validateLogin(email: String, password: String) -> Bool {
            if email.count < 5 || email.count > 50 || !email.contains("@") {
                validationError = "The e-mail address must contain '@' and be at least 5 characters long"
                return false
            }
            if password.count < 8 {
                validationError = "The password does not contain the minimum amount of characters"
                return false
            }
            validationError = ""
            return true
        }
}

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
    //@State var serverResponse: String = "AA"
    var body: some View {
        Step(inputs: $loginInputs, fields: loginFields, icons: loginIcons, currentStep: $step, error: $viewModel.validationError, call: { viewModel.login(email: loginInputs[0][0], password: loginInputs[0][1])}, links: true, title: "Log in", postStep: 0, serverResponse: $viewModel.serverResponse).onReceive(viewModel.$serverResponse) {
                    response in
                    if response == "Login successful!" {
                        SessionManager.shared.isLoggedIn = true
                        self.isLoggedIn = true
                    }
        }.removeFocusOnTap()
    }
        //Text("Hello")
    }
    
