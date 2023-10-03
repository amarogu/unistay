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
    func register(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage?, doubleLocCoordinates: [[Double]], currency: String, completion: @escaping (String?, Error?) -> Void) {
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
        }, to: "http://172.20.10.9:3000/register/normal", method: .post)
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
    
    func registerProvider(username: String, email: String, password: String, publisherBio: String, profilePicture: UIImage?, locatedAtCoordinates: [Double], pubLoc: [Double], currency: String, publicationTitle: String, publicatioDesc: String, publicationRent: Double, publicationType: String, visibility: String, images: [UIImage]) {
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
        
            let pubLoc: [String: Any] = [
                "latitude": pubLoc[0],
                "longitude": pubLoc[1]
            ]
            
            //var imagesPng: [Data?] = []
            
            AF.upload(multipartFormData: { multipartFormData in
                if let accProviderData = try? JSONSerialization.data(withJSONObject: accProviderData),
                   let locatedAtData = try? JSONSerialization.data(withJSONObject: locatedAtData),
                   let publicationData = try? JSONSerialization.data(withJSONObject: publicationData),
                   let pubLoc = try? JSONSerialization.data(withJSONObject: pubLoc),
                   let profilePicture = profilePicture?.pngData() {
                    multipartFormData.append(accProviderData, withName: "userData")
                    multipartFormData.append(locatedAtData, withName: "locAtData")
                    multipartFormData.append(publicationData, withName: "publicationData")
                    multipartFormData.append(profilePicture, withName: "image", fileName: "\(UUID()).png", mimeType: "image/png")
                    multipartFormData.append(pubLoc, withName: "pubLoc")
                    for (_, image) in images.enumerated() {
                               if let imageData = image.pngData() {
                                   multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
                               }
                           }
                }
                
                
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
