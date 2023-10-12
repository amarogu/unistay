//
//  UserRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 11/10/23.
//

import SwiftUI
import Alamofire

class PropertyChangeResponse: Decodable {
    let message: String
}

class PropertyChangeError: Decodable {
    let error: Int
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

func updateProfilePicture(_ image: UIImage?) {
    AF.upload(multipartFormData: { multipartFormData in
        if let imageData = image?.pngData() {
            multipartFormData.append(imageData, withName: "images", fileName: "\(UUID()).png", mimeType: "image/png")
        }
        debugPrint(multipartFormData)
    }, to: "http://localhost:3000/user/profilepicture", method: .put)
    .responseDecodable(of: ServerResponseSignup.self) { response in
        debugPrint(response)
    }
}

func changeProperty(_ property: String, _ content: String, completion: @escaping (PropertyChangeResult?, Error?) -> Void) {
    let parameters = [
        property: content
    ]
    NetworkManager.shared.request("http://localhost:3000/user/\(property)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: PropertyChangeResult.self) {
        response in
        debugPrint(response)
            switch response.result {
            case .success(let value):
                switch value {
                case .response(let response):
                    completion(.response(response), nil)
                case .error(let error):
                    completion(.error(error), nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
    }
}
