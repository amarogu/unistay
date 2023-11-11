//
//  Publicationrequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 15/10/23.
//

import SwiftUI
import Alamofire

// MARK: RESPONSE MODELS

class PubResponse: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct PubLocation: Decodable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct Title: Decodable {
    let original: String
    let en: String
    let pt: String
    let fr: String
}

struct Description: Decodable {
    let original: String
    let en: String
    let pt: String
    let fr: String
}

class AccommodationResponse: Decodable, Hashable {
    let _id: String
    let title: Title
    let description: Description
    let rent: Int
    let currency: String
    let type: String
    let postLanguage: String
    let owner: String
    let visibility: String
    let chats: [String]
    let connectedUsers: [String]
    let images: [String]
    let location: PubLocation
    let rating: Int
    let __v: Int
    
    init(_id: String, title: Title, description: Description, rent: Int, currency: String, type: String, postLanguage: String, owner: String, visibility: String, chats: [String], connectedUsers: [String], images: [String], location: PubLocation, rating: Int, __v: Int) {
        self._id = _id
        self.title = title
        self.description = description
        self.rent = rent
        self.currency = currency
        self.type = type
        self.postLanguage = postLanguage
        self.owner = owner
        self.visibility = visibility
        self.chats = chats
        self.connectedUsers = connectedUsers
        self.images = images
        self.location = location
        self.rating = rating
        self.__v = __v
    }
    
    enum CodingKeys: String, CodingKey {
        case _id, title, description, rent, currency, type, postLanguage, owner, visibility, chats, connectedUsers, images, location, rating, __v
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
        
    static func == (lhs: AccommodationResponse, rhs: AccommodationResponse) -> Bool {
        return lhs._id == rhs._id
    }
}

// MARK: FUNCTIONS

func connectUser(_ id: String) async throws -> PubResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<PubResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)user/publication/?id=\(id)", method: .put, encoding: JSONEncoding.default).responseDecodable(of: PubResponse.self) {
            res in
            debugPrint(res)
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let err):
                continuation.resume(throwing: err)
            }
        }
    }
    
    return res
}

func fetchConnectedUsers(_ publication: String) async throws -> [Participant] {
    let response = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<[Participant], Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)publication/connectedusers/?id=\(publication)", method: .get, encoding: JSONEncoding.default).responseDecodable(of: [Participant].self) {
            response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    return response
}

func postPublication(title: [String: String], description: [String: String], rent: Double, currency: String, type: String, postLanguage: String, visibility: String, pubLoc: [Double?], images: [UIImage]) async throws -> PubResponse {
    let location = [
        "latitude": pubLoc[0],
        "longitude": pubLoc[1]
    ]
    
    let parameters: [String: Any] = [
        "title": title,
        "description": description,
        "rent": rent,
        "type": type,
        "visibility": visibility,
        "location":location
    ]
    
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<PubResponse, Error>) in
        AF.upload(multipartFormData: {
            multipartFormData in
            if let params = try? JSONSerialization.data(withJSONObject: parameters) {
                debugPrint(params)
                multipartFormData.append(params, withName: "publication")
            }
            for img in images {
                if let img = img.jpegData(compressionQuality: 0.6) {
                    debugPrint(img)
                    multipartFormData.append(img, withName: "images", fileName: "\(UUID()).jpg", mimeType: "image/png")
                }
            }
        }, to: "\(Global.shared.apiUrl)createpublication", method: .post).responseDecodable(of: PubResponse.self) {
            res in
            debugPrint(res)
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let err):
                continuation.resume(throwing: err)
            }
        }
    }
    
    return res
}

func getYourPubs(_ id: String) async throws -> [AccommodationResponse] {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<[AccommodationResponse], Error>) in
        
        NetworkManager.shared.request("\(Global.shared.apiUrl)yourpublications", method: .get).responseDecodable(of: [AccommodationResponse].self) {
            res in
            debugPrint(res)
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let err):
                continuation.resume(throwing: err)
            }
        }
    }
    
    return res
}

func getNearestTo(_ lat: Double, _ lng: Double) async throws -> [AccommodationResponse] {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<[AccommodationResponse], Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)nearest-to/?lat=\(lat)&lng=\(lng)", method: .get).responseDecodable(of: [AccommodationResponse].self) {
            res in
            debugPrint(res)
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let err):
                continuation.resume(throwing: err)
            }
        }
    }
    
    return res
}

func savePublication(_ id: String, _ add: Bool) async throws -> GeneralResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)publication/save/?id=\(id)&add=\(add)", method: .put).responseDecodable(of: GeneralResponse.self) {
            res in
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let err):
                continuation.resume(throwing: err)
            }
        }
    }
    
    return res
}
