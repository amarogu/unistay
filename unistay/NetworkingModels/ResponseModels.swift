//
//  ResponseModels.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import Foundation

// MARK: GENERAL RESPONSE MODELS

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

class GeneralResponse: Decodable {
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



class profPic: Decodable {
    let _id: String
    let referenceId: String
    let onModel: String
    let path: String
    let position: Int
    let cover: Bool
    let __v: Int
}
