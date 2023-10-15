//
//  Publicationrequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 15/10/23.
//

import SwiftUI
import Alamofire

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
