//
//  GetRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI
import SocketIO

func getUser(completion: @escaping (User?, Error?) -> Void) {
    NetworkManager.shared.request("\(Global.shared.apiUrl)user", method: .get).responseDecodable(of: User.self) { response in
        debugPrint(response)
        switch response.result {
        case .success(let value):
            completion(value, nil)
        case .failure(let error):
            completion(nil, error)
        }
    }
}

func getProfPic() {
    NetworkManager.shared.request("\(Global.shared.apiUrl)user/profilepicture", method: .get).responseDecodable(of: profPic.self) {
        response in
        debugPrint(response)
    }
}

class ImageDownloader: ObservableObject {
    @Published var downloadedImage: UIImage?
    
    func downloadProfPic() {
        NetworkManager.shared.download("\(Global.shared.apiUrl)user/profilepicture").responseURL {
            response in
            debugPrint(response.fileURL as Any)
            if let url = response.fileURL {
                let image = UIImage(contentsOfFile: url.path)
                DispatchQueue.main.async {
                    self.downloadedImage = image
                    debugPrint(self.downloadedImage as Any)
                }
            }
        }
    }
    
    func downloadUserImage(_ userId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        NetworkManager.shared.download("\(Global.shared.apiUrl)user/profilepicture/?id=\(userId)").responseURL {
            response in
            debugPrint(response.fileURL as Any)
            if let url = response.fileURL {
                let image = UIImage(contentsOfFile: url.path)
                DispatchQueue.main.async {
                    switch response.result {
                    case .success:
                        completion(image, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
            }
        }
    }
}

func getPubs(completion: @escaping ([AccommodationResponse?], Error?) -> Void) {
    NetworkManager.shared.request("\(Global.shared.apiUrl)nearest", method: .get).responseDecodable(of: [AccommodationResponse].self) {
        response in
        debugPrint(response)
        switch response.result {
        case .success(let value):
            completion(value, [] as? Error)
        case .failure(let error):
            completion([], error)
        }
    }
}

class ObservableChat: ObservableObject {
    @Published var chatsArray: [Chat] = []
    
    func fetchChats(completion: @escaping ([Chat]?, Error?) -> Void) {
        let url = "\(Global.shared.apiUrl)chats"
        
        NetworkManager.shared.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Chat].self) { response in
                
                switch response.result {
                case .success(let chats):
                    completion(chats, nil)
                    for result in chats {
                        
                            self.chatsArray.append(result)
                        
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                
                }
            }
    }
}

class NewConnection: Decodable, Hashable, Identifiable, ObservableObject {
    var id: UUID = UUID()
    let newUser: User
    let publication: AccommodationResponse
    
    enum CodingKeys: String, CodingKey {
        case newUser, publication
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NewConnection, rhs: NewConnection) -> Bool {
        return lhs.id == rhs.id
    }
}

class WebSocketManager: ObservableObject {
    let manager: SocketManager
    @Published var newConn: Bool = false
    @Published var newConnArray: [NewConnection] = []
    @Published var fetchChat: Bool = false
    
    init() {
        let socketURL = URL(string: "http://api.unistay.studio:8080")!
        let config: SocketIOClientConfiguration = [
            .log(true),
            .compress,
            .connectParams(["cookies": checkCookies()])
        ]
        self.manager = SocketManager(socketURL: socketURL, config: config)
    }

    func connect() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {
            data, ack in
            print("socket connected")
        }
        socket.connect()
    }

    func receiveMessage() {
        let socket = manager.defaultSocket
        socket.on("message") { _, _ in
            self.fetchChat = true
        }
        
    }
    
    func receiveNewConnection() {
        let socket = manager.defaultSocket
                socket.on("newConn") {
                    data, _ in
                    print(data)
                    guard let connData = data[0] as? [String: Any] else {
                        print("Unable to convert data to message")
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: connData, options: .prettyPrinted)
                        let decodedNewConn = try JSONDecoder().decode(NewConnection.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.newConn = true
                            self.newConnArray.append(decodedNewConn)
                        }
                    } catch {
                        
                    }
                }
    }

    
    func disconnect() {
            let socket = manager.defaultSocket
            socket.disconnect()
            print("socket disconnected")
        }
}

enum CustomError: Error {
    case unableToConvertDataToMessage
}
