//
//  UserRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 11/10/23.
//

import SwiftUI
import Alamofire
import Nuke

class PropertyChangeResponse: Decodable {
    let message: String
}

class PropertyChangeError: Decodable, Error {
    let error: Int
}

class ExtraneousUser: Decodable {
    let _id: String
    let bio: String
    let profilePicture: String
    let accountType: String
    let username: String
    let connectedPublications: [AccommodationResponse]
    let name: String
    let surname: String
    
    init() {
        self._id = ""
        self.bio = ""
        self.profilePicture = ""
        self.accountType = ""
        self.username = ""
        self.connectedPublications = []
        self.name = ""
        self.surname = ""
    }
}

enum PropertyChangeResult: Decodable {
    case response(PropertyChangeResponse)
    case error(PropertyChangeError)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let response = try? container.decode(PropertyChangeResponse.self) {
            self = .response(response)
        } else if let error = try? container.decode(PropertyChangeError.self) {
            self = .error(error)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode PropertyChangeResult")
        }
    }
}

func updateProfilePicture(_ image: UIImage?) async throws -> ServerResponseSignup {
    let response = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<ServerResponseSignup, Error>) in
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = image?.pngData() {
                multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
            }
            debugPrint(multipartFormData)
        }, to: "http://localhost:3000/user/profilepicture", method: .put)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                continuation.resume(returning: value)
                let url = URL(string: "http://localhost:3000/user/profilepicture")
                let request = ImageRequest(url: url)
                ImageCache.shared[ImageCacheKey(request: request)] = nil
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    return response
}

func changeProperty(_ property: String, _ content: String) async throws -> PropertyChangeResult {
    let parameters = [
        property: content
    ]
    
    let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PropertyChangeResult, Error>) in
        NetworkManager.shared.request("http://localhost:3000/user/\(property)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: PropertyChangeResult.self) { response in
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

func getExtraneousUser(_ id: String) async throws -> ExtraneousUser {
    let response = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<ExtraneousUser, Error>) in
        NetworkManager.shared.request("http://localhost:3000/userprofile/?id=\(id)", method: .get, encoding: JSONEncoding.default).responseDecodable(of: ExtraneousUser.self) {
            response in
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
