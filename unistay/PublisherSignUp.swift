//
//  SwiftUIView.swift
//  unistay
//
//  Created by Gustavo Amaro on 05/09/23.
//

import SwiftUI
import Combine

class PublisherSignUpViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
    @Published var validationError: String = ""
    var cancellables = Set<AnyCancellable>()
    func signUp(inputs: [[String]], step: Int) {
        if !validatePublisherSignUp(inputs: inputs, step: step) {
            return
        }
        let url = URL(string: "http://localhost:3000/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData: [String: Any] = ["user": ["username": inputs[0][0], "email": inputs[0][1], "profilePicture": inputs[1][0], "language": "English", "accountType": "publisher", "password": inputs[0][3], "private": true, "currency": inputs[2][1], "preferredLocations": inputs[2][0]] as [String : Any]]
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
    func validatePublisherSignUp(inputs: [[String]], step: Int) -> Bool {
        switch step {
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
            let location = inputs[2][0]
            let currency = inputs[2][1]
            if location.isEmpty {
                validationError = "Please insert your location"
                return false
            }
            if currency.isEmpty {
                validationError = "Please insert your preferred currency"
                return false
            }
        case 3:
            // Validate publication fields
            let title = inputs[3][0]
            let description = inputs[3][1]
            let rent = inputs[3][2]
            let currency = inputs[3][3]
            let type = inputs[3][4]
            if title.isEmpty || title.count > 50 {
                validationError = "Please insert a valid title (up to 50 characters)"
                return false
            }
            if description.isEmpty || description.count > 500 {
                validationError = "Please insert a valid description (up to 500 characters)"
                return false
            }
            if let rentValue = Int(rent), rentValue < 100 || rentValue > 100000 {
                validationError = "Please insert a valid rent value (between 100 and 100000)"
                return false
            }
            if currency.isEmpty {
                validationError = "Please insert a currency"
                return false
            }
            if type.isEmpty || !["oncampus", "offcampus", "homestay"].contains(type) {
                validationError = "Please choose a valid publication type"
                return false
            }
        case 4:
            // Validate publication visibility, location, and images
            let visibility = inputs[4][0]
            let pubLocation = inputs[4][1]
            let images = inputs[4][2]
            if visibility.isEmpty || !["visible", "invisible"].contains(visibility) {
                validationError = "Please choose a valid visibility option"
                return false
            }
            if pubLocation.isEmpty {
                validationError = "Please insert a publication location"
                return false
            }
            if images.isEmpty {
                validationError = "Please upload at least one image"
                return false
            }
        default:
            validationError = "Internal error"
            return false
        }
        validationError = ""
        return true
    }

}


struct PublisherSignUp: View {
    @State var signupInputs: [[String]] = [["", "", "", "", ""], ["", ""], ["", ""], ["", "", "", "", "", "", "", ""], ["", "", ""]]
       var signupFields: [[String]] = [["Username", "E-mail address", "Confirm your e-mail address", "Password", "Confirm your password"], ["Upload a profile picture", "Insert your publisher bio"], ["Your location", "Currency"], ["Publication title", "Publication description", "Rent", "Currency", "Type"], ["Publication visibility", "Publication location", "Publication images"]]
       @State var signupIcons: [[String]] = [["person.crop.circle", "envelope", "checkmark.circle", "key", "checkmark.circle"], ["camera.circle", "bubble.right.circle"], ["location.circle", "dollarsign.circle"], ["book.circle", "text.justify", "bitcoinsign.circle", "dollarsign.circle", "circle.dashed"], ["eye.circle", "location.circle", "camera.circle.fill"]]
       @State var step: Int = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
