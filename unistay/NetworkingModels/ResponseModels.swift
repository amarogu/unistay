//
//  ResponseModels.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import Foundation

class ServerResponseLogin: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

class ServerResponseSignup: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct Location: Decodable {
    let latitude: Double
    let longitude: Double
    let _id: String
}

class User: Decodable {
    let _id: String
    let username: String
    let name: String
    let surname: String
    let email: String
    let language: String
    let password: String
    let preferredLocations: [Location]
    let isPrivate: Bool
    let currency: String
    let savedPublications: [String]
    let connectedPublications: [String]
    let owns: [String]
    let bio: String
    let profilePicture: String
    let accountType: String
    let locatedAt: [String]
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, username, name, surname, email, language, password, preferredLocations, currency, savedPublications, connectedPublications, owns, bio, profilePicture, accountType, locatedAt, __v
        case isPrivate = "private"
    }
}


class profPic: Decodable {
    let _id: String
    let referenceId: String
    let onModel: String
    let path: String
    let position: Int
    let cover: Bool
    let __v: Int
}

struct PubLocation: Decodable, Hashable {
    let latitude: Double
    let longitude: Double
}

class AccommodationResponse: Decodable, Hashable {
    let id: UUID = UUID()
    let _id: String
    let title: String
    let description: String
    let rent: Int
    let currency: String
    let type: String
    let postLanguage: String
    let owner: String
    let visibility: String
    let chats: [String]
    let connectedUsers: [String]
    let images: [String]
    let location: PubLocation
    let rating: Int
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, title, description, rent, currency, type, postLanguage, owner, visibility, chats, connectedUsers, images, location, rating, __v
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    static func == (lhs: AccommodationResponse, rhs: AccommodationResponse) -> Bool {
        return lhs.id == rhs.id
    }
}

class Chat: Decodable, Identifiable {
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
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, creator, publicationAssociated, participants, createdAt, updatedAt, __v
    }
}

class Participant: Decodable, Identifiable {
    var id = UUID()
    let _id: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case _id, username
    }
}
