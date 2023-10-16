//
//  Register.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI
import Alamofire

class Register: ObservableObject {
    @Published var response: String = ""
    func register(username: String, email: String, password: String, bio: String, name: String, surname: String, profilePicture: UIImage?, doubleLocCoordinates: [[Double]], currency: String, completion: @escaping (String?, Error?) -> Void) {
        var preferredLocations: [[String: Any]] = []
        for coord in doubleLocCoordinates {
            preferredLocations.append(["latitude": coord[0], "longitude": coord[1]])
        }
        
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "language": "en",
            "private": false,
            "currency": currency,
            "savedPublications": [],
            "connectedPublications": [],
            "twofactorAuthentication": false,
            "accountType": "student",
            "owns": [],
            "bio": bio,
            "name": name,
            "surname": surname,
            "preferredLocations": preferredLocations
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let userData = try? JSONSerialization.data(withJSONObject: userData),
               let profilePicture = profilePicture?.pngData() {
                multipartFormData.append(userData, withName: "userData")
                multipartFormData.append(profilePicture, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
            }
        }, to: "http://localhost:3000/register", method: .post)
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


    
    func registerProvider(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage?, locatedAtCoordinates: [Double?], pubLoc: [Double], currency: String, publicationTitle: String, publicatioDesc: String, publicationRent: Double, publicationType: String, visibility: String, images: [UIImage], name: String, surname: String) {
        let locatedAtData: [String: Any] = [
            "latitude": locatedAtCoordinates[0],
            "longitude": locatedAtCoordinates[1]
        ]
        
        let pubLocData: [String: Any] = [
            "latitude": pubLoc[0],
            "longitude": pubLoc[1]
        ]
        
        let accProviderData: [String: Any] = [
            "username": username,
            "email": email,
            "name": name,
            "surname": surname,
            "password": password,
            "language": "en",
            "accountType": "provider",
            "private": false,
            "currency": currency,
            "savedPublications": [],
            "connectedPublications": [],
            "twofactorAuthentication": false,
            "owns": [],
            "locatedAt": locatedAtData
        ]
        
        let publicationData: [String: Any] = [
            "title": publicationTitle,
            "description": publicatioDesc,
            "rent": publicationRent,
            "type": publicationType,
            "visibility": visibility,
            "location": pubLocData
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let accProviderData = try? JSONSerialization.data(withJSONObject: accProviderData),
               let publicationData = try? JSONSerialization.data(withJSONObject: publicationData),
               let profilePicture = profilePicture?.pngData() {
                multipartFormData.append(accProviderData, withName: "userData")
                multipartFormData.append(publicationData, withName: "publicationData")
                multipartFormData.append(profilePicture, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
                for (_, image) in images.enumerated() {
                    if let imageData = image.pngData() {
                        multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
                    }
                }
            }
            debugPrint(multipartFormData)
        }, to: "http://localhost:3000/register", method: .post)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
        }
    }

    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        AF.request("http://172.20.10.9:3000/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
}
