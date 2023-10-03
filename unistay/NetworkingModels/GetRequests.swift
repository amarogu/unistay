//
//  GetRequests.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI

func getUser(completion: @escaping (User?, Error?) -> Void) {
    NetworkManager.shared.request("http://172.20.10.9:3000/user", method: .get).responseDecodable(of: User.self) { response in
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
    NetworkManager.shared.request("http://172.20.10.9:3000/user/profilepicture", method: .get).responseDecodable(of: profPic.self) {
        response in
        debugPrint(response)
    }
}

class ImageDownloader: ObservableObject {
    @Published var downloadedImage: UIImage?
    
    func downloadProfPic() {
        NetworkManager.shared.download("http://172.20.10.9:3000/user/profilepicture").responseURL {
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
}
