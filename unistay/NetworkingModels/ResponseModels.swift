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
    let __v: Int

    enum CodingKeys: String, CodingKey {
        case _id, username, name, surname, email, language, password, preferredLocations, currency, savedPublications, connectedPublications, owns, bio, profilePicture, accountType, locatedAt, __v
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
    }
}

class ObservableUser: ObservableObject {
    @Published var user: User?

    init() {
        self.user = nil
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

class Participant: Decodable, Identifiable {
    var id = UUID()
    let _id: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case _id, username
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

