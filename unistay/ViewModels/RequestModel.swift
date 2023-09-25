//
//  RequestModel.swift
//  unistay
//
//  Created by Gustavo Amaro on 19/09/23.
//

import SwiftUI
import Combine

struct ServerResponseSignup: Codable {
    let message: String
}

class ServerResponseLogin: Codable {
    var message: String
}

class SignUpViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
    @Published var validationError: String = ""
    var cancellables = Set<AnyCancellable>()
    
    func login(email: String, password: String) {
        let url = URL(string: "http://localhost:3000/login")! // Update with your login endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyData: [String: Any] = [
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        request.httpBody = jsonData
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 401 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ServerResponseLogin.self, decoder: JSONDecoder()) // Update with your login response type
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

    
    func register(isToggled: Binding<Bool>, userData: [Any]) {
        let url = URL(string: "http://localhost:3000/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyData: [String: Any] = [
                "username": userData[0],
                "email": userData[1],
                "language": "en",
                "accountType": userData[2] as? Bool == true ? "publisher" : "normal",
                "password": userData[3],
                "preferredLocations": userData[4],
                "private": false,
                "currency": userData[6],
                "savedPublications": [String](),
                "connectedPublications": [String](),
                "twoFactorAuthentication": false,
                "profilePicture": "",
                "owns": [String](),
                "locatedAt": userData[7]
        ] as [String : Any]
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
                self?.serverResponse = response.message
            })
            .store(in: &cancellables)
    }
    
    func uploadImage(image: UIImage) {
        let url = URL(string: "http://localhost:3000/user/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Accept": "application/json"
        ]
        let session = URLSession(configuration: config)
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func uploadImages(images: [UIImage]) {
        let url = URL(string: "http://localhost:3000/user/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Accept": "application/json"
        ]
        
        let session = URLSession(configuration: config)
        
        var data = Data()
        
        for (index, image) in images.enumerated() {
            let imageData = image.jpegData(compressionQuality: 1.0)
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image\(index)\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData!)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func updateBio(bio: String) {
        let url = URL(string: "http://localhost:3000/user/bio")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData: [String: Any] = ["bio": bio]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func validateBio(bio: String) -> Bool {
        let bio = bio
        if bio.count < 15 {
            validationError = "The bio needs to be at least 15 characters long"
            return false
        } else {
            return true
        }
    }

    func validateSignUp(inputs: [String], isToggled: Binding<Bool>) -> Bool {
        let username = inputs[0]
        let email = inputs[1]
        let emailConfirm = inputs[2]
        let password = inputs[3]
        let passwordConfirm = inputs[4]
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
            
        validationError = ""
        return true
    }
    
    func hasProfileImage(profileImage: UIImage?) -> Bool {
        if let _ = profileImage {
            validationError = ""
            return true
        } else {
            validationError = "Please insert a profile picture"
            return false
        }
    }
    
    func hasMultipleImages(images: [UIImage]) -> Bool {
        if images.count > 2 {
            validationError = ""
            return true
        } else {
            validationError = "You need to insert at least three images"
            return false
        }
    }
    
    func validateLocation(loc: String) -> Bool {
        if loc.isEmpty {
            validationError = "You need to insert a location"
            return false
        } else {
            validationError = ""
            return true
        }
    }
    
    func validatePublication(data: [String]) -> Bool {
        let title = data[0]
        let desc = data[1]
        let rent = data[2]
        if title.count <= 5 {
            validationError = "You need to isnert a title that is bigger than 5 characters"
            return false
        }
        
        if title.count >= 25 {
            validationError = "Your title cannot be longer than 25 characters"
            return false
        }
        
        if desc.count <= 60 {
            validationError = "Your publication description needs to be at least 60 characters long"
            return false
        }
        
        if desc.count >= 600 {
            validationError = "Your description cannot be longer than 600 characters"
            return false
        }
        
        if Int(rent)! <= 200 {
            validationError = "Your rent value seems too low."
            return false
        }
        
        if Int(rent)! >= 10000 {
            validationError = "Your rent value seems too big"
            return false
        }
        
        validationError = ""
        return true
    }
}
