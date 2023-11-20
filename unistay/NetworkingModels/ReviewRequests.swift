//
//  ReviewRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 20/11/23.
//

import Foundation
import Alamofire

class Review: Decodable {
    let _id: String
    let publicationId: String
    let userId: String
    let rating: Double
    let comment: String
}

func review(_ id: String) async throws -> GeneralResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)review/?id=\(id)", method: .post).responseDecodable(of: GeneralResponse.self) {
            res in
            print("\(Global.shared.apiUrl)review/?id=\(id)")
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