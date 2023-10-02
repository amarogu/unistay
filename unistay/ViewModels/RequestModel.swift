//
//  RequestModel.swift
//  unistay
//
//  Created by Gustavo Amaro on 19/09/23.
//

import SwiftUI
import Combine
import Alamofire

extension LocalizedStringKey {
    var isEmpty: Bool {
            // Mirror the `LocalizedStringKey` to access its internal `key` property
            let mirror = Mirror(reflecting: self)
            if let key = mirror.children.first(where: { $0.label == "key" })?.value as? String {
                return key.isEmpty
            }
            return true
        }
}

struct ServerResponseSignup: Decodable {
    let message: String
}

class ServerResponseLogin: Codable {
    let message: String
}

class profPic: Decodable {
    let _id: String
    let referenceId: String
    let onModel: String
    let path: String
    let position: Int
    let cover: Bool
    let __v: Int
}

class User: Decodable {
    let _id: String
    let username: String
    let name: String
    let surname: String
    let email: String
    let language: String
    let password: String
    let preferredLocations: [String]
    let isPrivate: Bool
    let currency: String
    let savedPublications: [String]
    let connectedPublications: [String]
    let owns: [String]
    let bio: String
    let profilePicture: String
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, username, name, surname, email, language, password, preferredLocations, currency, savedPublications, connectedPublications, owns, bio, profilePicture, __v
        case isPrivate = "private"
    }
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
    
    func register(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage?, doubleLocCoordinates: [[Double]], currency: String, completion: @escaping (String?, Error?) -> Void) {
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "language": "en",
            "accountType": "publisher",
            "private": false,
            "currency": currency,
            "savedPublications": [],
            "connectedPublications": [],
            "twofactorAuthentication": false,
            "owns": []
        ]
        
        var locationData: [[String: Any]] = []
        for coord in doubleLocCoordinates {
            locationData.append(["latitude": coord[0], "longitude": coord[1]])
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let userData = try? JSONSerialization.data(withJSONObject: userData),
               let locData = try? JSONSerialization.data(withJSONObject: locationData),
               let profilePicture = profilePicture?.pngData() {
                multipartFormData.append(userData, withName: "userData")
                /*for coord in locationData {
                    if let jsonLoc = try? JSONSerialization.data(withJSONObject: coord) {
                        multipartFormData.append(jsonLoc, withName: "locData")
                    }
                }*/
                multipartFormData.append(locData, withName: "locData")
                print(profilePicture)
                multipartFormData.append(profilePicture, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
            }
        }, to: "http://localhost:3000/register/normal", method: .post)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                completion(value.message, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
    func registerProvider(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage, locatedAtCoordinates: [Double], currency: String, publicationTitle: String, publicatioDesc: String, publicationRent: Double, publicationType: String, visibility: String, images: [UIImage]) {
        let accProviderData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "language": "en",
            "accountType": "provider",
            "private": false,
            "currency": currency,
            "savedPublications": [],
            "connectedPublications": [],
            "twofactorAuthentication": false,
            "owns": []
        ]
        
        let publicationData: [String: Any] = [
            "title": publicationTitle,
            "description": publicatioDesc,
            "rent": publicationRent,
            "type": publicationType,
            "visibility": visibility
        ]
        
        let locatedAtData: [String: Any] = [
            "latitude": locatedAtCoordinates[0],
            "longitude": locatedAtCoordinates[1]
        ]
        
        //var imagesPng: [Data?] = []
        
        AF.upload(multipartFormData: { multipartFormData in
            if let accProviderData = try? JSONSerialization.data(withJSONObject: accProviderData),
               let locatedAtData = try? JSONSerialization.data(withJSONObject: locatedAtData),
               let publicationData = try? JSONSerialization.data(withJSONObject: publicationData),
               let profilePicture = profilePicture.pngData() {
                multipartFormData.append(accProviderData, withName: "accProviderData")
                multipartFormData.append(locatedAtData, withName: "locAtData")
                multipartFormData.append(publicationData, withName: "publicationData")
                multipartFormData.append(profilePicture, withName: "image", fileName: "\(UUID()).png", mimeType: "image/png")
                
                for (_, image) in images.enumerated() {
                           if let imageData = image.pngData() {
                               multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
                           }
                       }
            }
            
            
        }, to: "http://localhost:3000/register/provider", method: .post)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        AF.request("http://localhost:3000/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ServerResponseLogin.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    completion(value.message, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    class NetworkManager {
        static let shared = NetworkManager()
        
        private let session: Session
        
        private init() {
            let configuration = URLSessionConfiguration.af.default
            configuration.httpCookieStorage = HTTPCookieStorage.shared
            self.session = Session(configuration: configuration)
            
            // Load cookies at the start
            loadCookies()
        }
        
        func request(_ url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
            return self.session.request(url, method: method, parameters: parameters, encoding: encoding)
        }
        
        func download(_ url: String) -> DownloadRequest {
            return self.session.download(url)
        }
        
        func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
            let parameters: [String: Any] = [
                "email": email,
                "password": password
            ]
            
            self.session.request("http://localhost:3000/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseDecodable(of: ServerResponseLogin.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let value):
                        // Save cookies after successful login
                        self.saveCookies()
                        completion(value.message, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
        }
        
        // Save cookies to UserDefaults
        private func saveCookies() {
            let cookiesData = try? NSKeyedArchiver.archivedData(withRootObject: HTTPCookieStorage.shared.cookies ?? [], requiringSecureCoding: false)
            UserDefaults.standard.set(cookiesData, forKey: "cookies")
        }
        
        // Load cookies from UserDefaults
        private func loadCookies() {
            if let cookiesData = UserDefaults.standard.data(forKey: "cookies"),
               let cookies = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cookiesData) as? [HTTPCookie] {
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }
    
    func getUser(completion: @escaping (User?, Error?) -> Void) {
        NetworkManager.shared.request("http://localhost:3000/user", method: .get).responseDecodable(of: User.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }

    }
    
    func getProfPic() {
        NetworkManager.shared.request("http://localhost:3000/user/profilepicture", method: .get).responseDecodable(of: profPic.self) {
            response in
            debugPrint(response)
        }
    }
    
    class ImageDownloader: ObservableObject {
        @Published var downloadedImage: UIImage?
        
        func downloadProfPic() {
            NetworkManager.shared.download("http://localhost:3000/user/profilepicture").responseURL {
                response in
                debugPrint(response.fileURL as Any)
                if let url = response.fileURL {
                    let image = UIImage(contentsOfFile: url.path)
                    DispatchQueue.main.async {
                        self.downloadedImage = image
                        debugPrint(self.downloadedImage as Any)
                    }
                }
            }
        }
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
    
    func validatePublication(title: String, desc: String, rent: String) -> Bool {
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
