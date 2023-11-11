//
//  UserRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 11/10/23.
//

import SwiftUI
import Alamofire
import Nuke

// MARK: RESPONSE MODELS

class PropertyChangeResponse: Decodable {
    let message: String
}

class PropertyChangeError: Decodable, Error {
    let error: Int
}

class User: ObservableObject, Decodable, Identifiable {
    @Published var _id: String
    @Published var username: String
    @Published var name: String
    @Published var surname: String
    @Published var email: String
    @Published var language: String
    @Published var password: String
    @Published var preferredLocations: [Location]
    @Published var isPrivate: Bool
    @Published var currency: String
    @Published var savedPublications: [String]
    @Published var connectedPublications: [String]
    @Published var owns: [String]
    @Published var bio: String
    @Published var profilePicture: String
    @Published var accountType: String
    @Published var locatedAt: [Location]
    @Published var backgroundImage: String
    let __v: Int

    enum CodingKeys: String, CodingKey {
        case _id, username, name, surname, email, language, password, preferredLocations, currency, savedPublications, connectedPublications, owns, bio, profilePicture, accountType, locatedAt, __v, backgroundImage
        case isPrivate = "private"
    }
    
    init() {
        self._id = ""
        self.username = ""
        self.name = ""
        self.surname = ""
        self.email = ""
        self.language = ""
        self.password = ""
        self.preferredLocations = []
        self.isPrivate = false
        self.currency = ""
        self.savedPublications = []
        self.connectedPublications = []
        self.owns = []
        self.bio = ""
        self.profilePicture = ""
        self.accountType = ""
        self.locatedAt = []
        self.__v = 0
        self.backgroundImage = ""
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        username = try container.decode(String.self, forKey: .username)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        email = try container.decode(String.self, forKey: .email)
        language = try container.decode(String.self, forKey: .language)
        password = try container.decode(String.self, forKey: .password)
        preferredLocations = try container.decode([Location].self, forKey: .preferredLocations)
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        currency = try container.decode(String.self, forKey: .currency)
        savedPublications = try container.decode([String].self, forKey: .savedPublications)
        connectedPublications = try container.decode([String].self, forKey: .connectedPublications)
        owns = try container.decode([String].self, forKey: .owns)
        bio = try container.decode(String.self, forKey: .bio)
        profilePicture = try container.decode(String.self, forKey: .profilePicture)
        accountType = try container.decode(String.self, forKey: .accountType)
        locatedAt = try container.decode([Location].self, forKey: .locatedAt)
        __v = try container.decode(Int.self, forKey: .__v)
        backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
    }
}

class ObservableUser: ObservableObject {
    @Published var user: User?

    init() {
        self.user = nil
    }
}

class ExtraneousUser: Decodable {
    let _id: String
    let bio: String
    let profilePicture: String
    let accountType: String
    let username: String
    let connectedPublications: [String]
    let name: String
    let surname: String
    let backgroundImage: String
    
    init() {
        self._id = ""
        self.bio = ""
        self.profilePicture = ""
        self.accountType = ""
        self.username = ""
        self.connectedPublications = []
        self.name = ""
        self.surname = ""
        self.backgroundImage = ""
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

// MARK: FUNCTIONS

func updateProfilePicture(_ image: UIImage?) async throws -> ServerResponseSignup {
    let response = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<ServerResponseSignup, Error>) in
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = image?.pngData() {
                multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
            }
            debugPrint(multipartFormData)
        }, to: "\(Global.shared.apiUrl)user/profilepicture", method: .put)
        .responseDecodable(of: ServerResponseSignup.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                continuation.resume(returning: value)
                let url = URL(string: "\(Global.shared.apiUrl)user/profilepicture")
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
        NetworkManager.shared.request("\(Global.shared.apiUrl)user/\(property)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: PropertyChangeResult.self) { response in
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
        NetworkManager.shared.request("\(Global.shared.apiUrl)userprofile/?id=\(id)", method: .get, encoding: JSONEncoding.default).responseDecodable(of: ExtraneousUser.self) {
            response in
            switch response.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    print(response)
    return response
}

func validateUsername(_ username: String) async throws -> GeneralResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)user/validate/username/?username=\(username)", method: .post, encoding: JSONEncoding.default).responseDecodable(of: GeneralResponse.self) {
            res in
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    return res
}

func validateEmail(_ email: String) async throws -> GeneralResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)user/validate/email/?email=\(email)", method: .post, encoding: JSONEncoding.default).responseDecodable(of: GeneralResponse.self) {
            res in
            switch res.result {
            case .success(let value):
                continuation.resume(returning: value)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    return res
}
