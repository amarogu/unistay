//
//  ChatRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 10/10/23.
//

import SwiftUI
import Alamofire

// MARK: RESPONSE MODELS
class Message: Decodable, Identifiable {
    var id = UUID()
    let _id: String
    let senderId: String
    let chatId: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, senderId, chatId, content, createdAt, updatedAt, __v
    }
}

class ChatResponse: Decodable {
    let message: String
    let chatId: String
}

class Participant: Decodable, Identifiable {
    var id = UUID()
    let _id: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case _id, username
    }
    
    init(id: UUID = UUID(), _id: String, username: String) {
        self.id = id
        self._id = _id
        self.username = username
    }
}

class Chat: ObservableObject, Identifiable, Decodable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    let _id: String
    let creator: String
    let publicationAssociated: Bool
    let participants: [Participant]
    let createdAt: String
    let updatedAt: String
    @Published var messages: [Message] = []
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, creator, publicationAssociated, participants, createdAt, updatedAt, __v, messages
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        creator = try container.decode(String.self, forKey: .creator)
        publicationAssociated = try container.decode(Bool.self, forKey: .publicationAssociated)
        participants = try container.decode([Participant].self, forKey: .participants)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        messages = try container.decode([Message].self, forKey: .messages)
        __v = try container.decode(Int.self, forKey: .__v)
    }
}

// MARK: FUNCTIONS

func postMessage(to: String, by: String, content: String, completion: @escaping (Chat?, Error?) -> Void) {
    let parameters: [String: Any] = [
            "chatId": to,
            "content": content
        ]
    
    NetworkManager.shared.request("\(Global.shared.apiUrl)message", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: Chat.self) {
        response in
        print(response.result)
        switch response.result {
        case .success(let value):
            completion(value, nil)
        case .failure(let error):
            completion(nil, error)
        }
    }
}

func createChat(associatedTo: String) async throws -> ChatResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<ChatResponse, Error>) in
        let params: [String: Any] = [
            "publicationAssociated": true,
            "publicationId": associatedTo
        ]
        
        NetworkManager.shared.request("\(Global.shared.apiUrl)chat", method: .post, parameters: params, encoding: JSONEncoding.default).responseDecodable(of: ChatResponse.self) {
            res in
            print(res.result)
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

func addUser(_ chatId: String, _ username: String) async throws -> GeneralResponse {
    let res = try await withCheckedThrowingContinuation {
        (continuation: CheckedContinuation<GeneralResponse, Error>) in
        print(chatId, username)
        NetworkManager.shared.request("\(Global.shared.apiUrl)chat/\(chatId)/?name=\(username)", method: .put, encoding: JSONEncoding.default).responseDecodable(of: GeneralResponse.self) {
            res in
            //print(res.result)
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
