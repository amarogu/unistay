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
    @Published var image: [UIImage?] = []
    
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
    
    func downloadImage(_ id: String, completion: @escaping () -> Void) {
        NetworkManager.shared.download("http://localhost:3000/image/\(id)").responseURL {
            response in
            
            if let url = response.fileURL {
                let image = UIImage(contentsOfFile: url.path)
                DispatchQueue.main.async {
                    self.image.append(image)
                    debugPrint(image)
                    completion()
                }
            }
        }
    }
}

func getPubs(completion: @escaping ([AccommodationResponse?], Error?) -> Void) {
    NetworkManager.shared.request("http://localhost:3000/nearest", method: .get).responseDecodable(of: [AccommodationResponse].self) {
        response in
            
            switch response.result {
            case .success(let value):
                completion(value, [] as? Error)
            case .failure(let error):
                completion([], error)
            }
    }
}
