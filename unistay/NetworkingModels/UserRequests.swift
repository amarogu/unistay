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

func changeProperty(_ property: String, _ content: String, completion: @escaping (PropertyChangeResponse?, Error?) -> Void) {
    let parameters = [
        property: content
    ]
    NetworkManager.shared.request("http://localhost:3000/user/\(property)", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: PropertyChangeResponse.self) {
        response in
        debugPrint(response)
        switch response.result {
        case .success(let value):
            completion(value, nil)
        case .failure(let error):
            completion(nil, error)
        }
    }
}
