//
//  RequestModel.swift
//  unistay
//
//  Created by Gustavo Amaro on 19/09/23.
//

import SwiftUI
import Combine
import Alamofire

struct ServerResponseSignup: Decodable {
    let message: String
}

class ServerResponseLogin: Codable {
    var message: String
}

class SignUpViewModel: ObservableObject {
    @Published var serverResponse: String? = nil
    @Published var validationError: String = ""
    var cancellables = Set<AnyCancellable>()
    
    func testRequest() {
        AF.request("http://localhost:3000/testrequest").response {
            response in
            debugPrint(response)
        }
    }
    
    func register(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage?, doubleLocCoordinates: [Double]) {
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "language": "en",
            "accountType": "normal",
            "private": false,
            "currency": "USD",
            "savedPublications": [],
            "connectedPublications": [],
            "twofactorAuthentication": false,
            "owns": [],
            "locatedAt": ""
        ]
        
        let locationData: [String: Any] = [
            "latitude": doubleLocCoordinates[0],
            "longitude": doubleLocCoordinates[1]
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let userData = try? JSONSerialization.data(withJSONObject: userData),
               let locationData = try? JSONSerialization.data(withJSONObject: locationData),
               let profilePicture = profilePicture?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(userData, withName: "userData")
                multipartFormData.append(locationData, withName: "locData")
                multipartFormData.append(profilePicture, withName: "profilePicture")
            }
        }, to: "http://localhost:3000/register", method: .post)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
        }
    }

    
    /*func register(isToggled: Binding<Bool>, userData: [Any], image: UIImage) {
        let url = "http://localhost:3000/register"
        
        AF.upload(multipartFormData: { multipartFormData in
            // Add JSON data
            let bodyData: [String: Any] = [
                "username": userData[0],
                "email": userData[1],
                "language": "en",
                "accountType": "normal",
                "password": userData[2],
                "private": false,
                "currency": userData[6],
                "savedPublications": [],
                "connectedPublications": [],
                "twoFactorAuthentication": false,
                "owns": [],
                "locatedAt": userData[7]
            ]
            if let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) {
                multipartFormData.append(jsonData, withName: "userData", mimeType: "application/json")
            }
            
            /*if let locationData = userData[5] as? [Double] {
                let latitude = locationData[0]
                let longitude = locationData[1]
                let location: [String: Any] = [
                    "latitude": latitude,
                    "longitude": longitude
                ]
                // use location
                if let locJsonData = try? JSONSerialization.data(withJSONObject: location) {
                    multipartFormData.append(locJsonData, withName: "locData", mimeType: "application/json")
                }
            }*/
            
            
            
            // Add image data
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", mimeType: "image/jpeg")
            }
        }, to: url)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
        }
    }*/

    
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
    
    /*func register(isToggled: Binding<Bool>, userData: [Any], image: UIImage) {
            let url = URL(string: "http://localhost:3000/register")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let multipart = MultipartFormData()
            
            // Add JSON data
            let bodyData: [String: Any] = [
                    "username": userData[0],
                    "email": userData[1],
                    "language": "en",
                    "accountType": "normal",
                    "password": userData[2],
                    "preferredLocations": userData[5],
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
            multipart.append(jsonData, withName: "userData", mimeType: "application/json")
            
            // Add image data
            let imageData = image.jpegData(compressionQuality: 0.8)!
            multipart.append(imageData, withName: "profilePicture", fileName: "image.jpg", mimeType: "image/jpeg")
            
            request.setValue(multipart.contentType, forHTTPHeaderField: "Content-Type")
            
            request.httpBody = multipart.data
            
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
        }*/

    
    /*func register(isToggled: Binding<Bool>, userData: [Any]) {
        let url = URL(string: "http://localhost:3000/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyData: [String: Any] = [
                "username": userData[0],
                "email": userData[1],
                "language": "en",
                "accountType": "normal",
                "password": userData[2],
                "preferredLocations": userData[5],
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
    }*/
    
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
