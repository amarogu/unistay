//
//  ReviewRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 20/11/23.
//

import Foundation
import Alamofire

class Review: Decodable, Hashable, Identifiable {
    let id = UUID()
    let _id: String
    let publicationId: String
    let userId: String
    let rating: Double
    let comment: String
    let reviewer: String
    
    enum CodingKeys: String, CodingKey {
        case _id, publicationId, userId, rating, comment, reviewer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
}

func review(_ id: String, rating: Int, comment: String) async throws -> GeneralResponse {
    let params = [
        "rating": rating,
        "comment": comment
    ] as [String : Any]
    
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)review/?id=\(id)", method: .post, parameters: params, encoding: JSONEncoding.default).responseDecodable(of: GeneralResponse.self) {
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

func getReview(_ id: String) async throws -> Review {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<Review, Error>) in
        NetworkManager.shared.request("\(Global.shared.apiUrl)review/?id=\(id)", method: .get, encoding: JSONEncoding.default).responseDecodable(of: Review.self) {
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
