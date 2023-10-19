//
//  Publicationrequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 15/10/23.
//

import SwiftUI
import Alamofire

class PubResponse: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

func connectUser(_ id: String) async throws -> PubResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<PubResponse, Error>) in
        NetworkManager.shared.request("http://localhost:3000/user/publication/?id=\(id)", method: .put, encoding: JSONEncoding.default).responseDecodable(of: PubResponse.self) {
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
        NetworkManager.shared.request("http://localhost:3000/publication/connectedusers/?id=\(publication)", method: .get, encoding: JSONEncoding.default).responseDecodable(of: [Participant].self) {
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

func postPublication(title: String, description: String, rent: Double, currency: String, type: String, postLanguage: String, visibility: String, pubLoc: [Double?], images: [UIImage]) async throws -> PubResponse {
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
                if let img = img.pngData() {
                    debugPrint(img)
                    multipartFormData.append(img, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
                }
            }
        }, to: "http://localhost:3000/createpublication", method: .post).responseDecodable(of: PubResponse.self) {
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
        
        NetworkManager.shared.request("http://localhost:3000/yourpublications", method: .get).responseDecodable(of: [AccommodationResponse].self) {
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
