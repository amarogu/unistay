//
//  SignUpView.swift
//  unistay
//
//  Created by Gustavo Amaro on 25/08/23.
//

import SwiftUI
import Combine

struct ServerResponseSignup: Codable {
    let responseMessage: String
}

class SignUpViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
    @Published var validationError: String = ""
    var cancellables = Set<AnyCancellable>()
    func signUp(inputs: [[String]], step: Binding<Int>, isToggleOn: Binding<Bool>) {
        if !validateSignUp(inputs: inputs, step: step, isToggleOn: isToggleOn) {
            return
        }
        let url = URL(string: "http://localhost:3000/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData: [String: Any] = ["user": ["username": inputs[0][0], "email": inputs[0][1], "language": "English", "accountType": "normal", "password": inputs[0][3], "private": true, "currency": inputs[2][1], "preferredLocations": inputs[2][0]] as [String : Any]]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        request.httpBody = jsonData

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 401 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ServerResponseSignup.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.serverResponse = response.responseMessage
            })
            .store(in: &cancellables)
    }
    func validateSignUp(inputs: [[String]], step: Binding<Int>, isToggleOn: Binding<Bool>) -> Bool {
        /*switch step.wrappedValue {
            case 0:
                let username = inputs[0][0]
                let email = inputs[0][1]
                let emailConfirm = inputs[0][2]
                let password = inputs[0][3]
                let passwordConfirm = inputs[0][4]
                if username.count < 3 || username.count > 20 {
                    validationError = "The username needs to be 3 to 20 characters long"
                    return false
                }
                if email != emailConfirm {
                    validationError = "The e-mail addresses do not match"
                    return false
                }
                if password != passwordConfirm {
                    validationError = "The passwords do not match"
                    return false
                }
                if email.count < 5 || email.count > 50 || !email.contains("@") {
                    validationError = "The e-mail address is not valid"
                    return false
                }
                if password.count < 8 || password.count > 50 {
                    validationError = "The password does not fit the criteria"
                    return false
                }
            case 1:
                let bio = inputs[1][1]
                if bio.isEmpty || bio.count > 325 {
                    validationError = "Please insert a valid bio"
                    return false
                }
            case 2:
                let preferredLocations = inputs[2][0]
                let preferredCurrency = inputs[2][1]
                if preferredLocations.isEmpty {
                    validationError = "Please insert at least one location"
                    return false
                }
                if preferredCurrency.isEmpty {
                    validationError = "Please insert at least one currency"
                    return false
                }
            default:
                validationError = "Internal error"
                return false
            }*/
        if step.wrappedValue == 4 {
            return true
        }
        step.wrappedValue+=1
        validationError = ""
        return true
        }
}

struct SignUpView: View {
    //@Binding var responseData: String
    @State var signupInputs: [[String]] = [["", "", "", "", "", ""], ["", ""], ["", ""]]
    @State var signupFields: [[String]] = [["Username", "E-mail address", "Confirm your e-mail address", "Password", "Confirm your password", "Sign up as a publisher account"], ["Upload a profile picture", "Insert a user bio"], ["Preferred locations", "Preferred currency"]]
    @State var signupIcons: [[String]] = [["person.crop.circle", "envelope", "checkmark.circle", "key", "checkmark.circle", "arrow.up.doc"], ["camera.circle", "bubble.right.circle"], ["location.circle", "dollarsign.circle"]]
    @State var step: Int = 0
    @StateObject private var viewModel = SignUpViewModel()
    @State var isToggleOn: Bool = false
    var body: some View {
        Step(inputs: $signupInputs, fields: signupFields, icons: signupIcons, currentStep: $step, error: $viewModel.validationError, call: { viewModel.signUp(inputs: signupInputs, step: $step, isToggleOn: $isToggleOn)}, links: false, title: "Sign up", postStep: 4, serverResponse: $viewModel.serverResponse, isToggleOn: $isToggleOn).onChange(of: signupInputs, perform: {
                    newValue in
                    let email = signupInputs[0][1]
                    let emailConfirm = signupInputs[0][2]
                    let password = signupInputs[0][3]
                    let passwordConfirm = signupInputs[0][4]
                    
                    if (email == emailConfirm && !email.isEmpty) {
                        signupIcons[0][2] = "checkmark.circle.fill"
                    } else {
                        signupIcons[0][2] = "checkmark.circle"
                    }
                    if (password == passwordConfirm && !password.isEmpty) {
                        signupIcons[0][4] = "checkmark.circle.fill"
                    } else {
                        signupIcons[0][4] = "checkmark.circle"
                    }
        }).onChange(of: isToggleOn, perform: {
            newValue in
            if newValue {
                //signupFields[0][5] = "hello"
                signupInputs.append(["", "", "", "", ""])
                signupInputs.append(["", "", ""])
                signupFields[1] = ["Upload a profile picture", "Insert your publisher bio"]
                signupFields[2] = ["Your location", "Currency"]
                signupFields.append(["Publication title", "Publication description", "Rent", "Currency", "Type"])
                signupFields.append(["Publication visibility", "Publication location", "Publication images"])
                signupIcons.append(["character.cursor.ibeam", "doc.richtext", "calendar.badge.plus", "dollarsign.circle", "house.and.flag"])
                signupIcons.append(["eye.circle", "location.circle", "photo.on.rectangle.angled"])
            } else {
                signupInputs.removeLast(2)
                signupFields[1] = ["Upload a profile picture", "Insert a user bio"]
                signupFields[2] = ["Preferred locations", "Preferred currency"]
                signupIcons.removeLast(2)
            }
        }).removeFocusOnTap()
    }
}

struct Provider_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


