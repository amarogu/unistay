//
//  GetRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI

func getUser(completion: @escaping (User?, Error?) -> Void) {
    NetworkManager.shared.request("http://localhost:3000/user", method: .get).responseDecodable(of: User.self) { response in
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
    NetworkManager.shared.request("http://localhost:3000/user/profilepicture", method: .get).responseDecodable(of: profPic.self) {
        response in
        debugPrint(response)
    }
}

class ImageDownloader: ObservableObject {
    @Published var downloadedImage: UIImage?
    
    func downloadProfPic() {
        NetworkManager.shared.download("http://localhost:3000/user/profilepicture").responseURL {
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
        NetworkManager.shared.download("http://localhost:3000/user/profilepicture/?id=\(userId)").responseURL {
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
    NetworkManager.shared.request("http://localhost:3000/nearest", method: .get).responseDecodable(of: [AccommodationResponse].self) {
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
        let url = "http://localhost:3000/chats"
        NetworkManager.shared.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Chat].self) { response in
                switch response.result {
                case .success(let chats):
                    completion(chats, nil)
                    for result in chats {
                        self.chatsArray.append(result)
                    }
                    debugPrint(response)
                case .failure(let error):
                    completion(nil, error)
                    debugPrint(response)
                }
            }
    }
}
