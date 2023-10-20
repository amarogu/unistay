//
//  ChatRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 10/10/23.
//

import SwiftUI
import Alamofire

func postMessage(to: String, by: String, content: String, completion: @escaping (Chat?, Error?) -> Void) {
    let parameters: [String: Any] = [
            "chatId": to,
            "content": content
        ]
    
    NetworkManager.shared.request("http://localhost:3000/message", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: Chat.self) {
        response in
        switch response.result {
        case .success(let value):
            completion(value, nil)
        case .failure(let error):
            completion(nil, error)
        }
    }
}
