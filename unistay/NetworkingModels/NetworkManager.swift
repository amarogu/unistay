//
//  NetworkManager.swift
//  unistay
//
//  Created by Gustavo Amaro on 03/10/23.
//

import SwiftUI
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        self.session = Session(configuration: configuration)
        
        // Load cookies at the start
        loadCookies()
    }
    
    func request(_ url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        return self.session.request(url, method: method, parameters: parameters, encoding: encoding)
    }
    
    func download(_ url: String) -> DownloadRequest {
        return self.session.download(url)
    }
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        self.session.request("http://localhost:3000/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ServerResponseLogin.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    // Save cookies after successful login
                    self.saveCookies()
                    completion(value.message, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    // Save cookies to UserDefaults
    private func saveCookies() {
        let cookiesData = try? NSKeyedArchiver.archivedData(withRootObject: HTTPCookieStorage.shared.cookies ?? [], requiringSecureCoding: false)
        UserDefaults.standard.set(cookiesData, forKey: "cookies")
    }
    
    // Load cookies from UserDefaults
    private func loadCookies() {
        if let cookiesData = UserDefaults.standard.data(forKey: "cookies"),
           let cookies = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cookiesData) as? [HTTPCookie] {
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}
