//
//  ResponseModels.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

class User: Decodable {
    let _id: String
    let username: String
    let name: String
    let surname: String
    let email: String
    let language: String
    let password: String
    let preferredLocations: [String]
    let isPrivate: Bool
    let currency: String
    let savedPublications: [String]
    let connectedPublications: [String]
    let owns: [String]
    let bio: String
    let profilePicture: String
    let accountType: String
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, username, name, surname, email, language, password, preferredLocations, currency, savedPublications, connectedPublications, owns, bio, profilePicture, accountType, __v
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
