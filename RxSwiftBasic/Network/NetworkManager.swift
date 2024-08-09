//
//  NetworkManager.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/9/24.
//

import Foundation

import RxSwift

enum NetworkError: Error {
    case invalidURL
    case unknown
    case status
    case noData
    case decoding
    
    var message: String {
        return "에러: " + String(describing: self)
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestAPIWithSingle<T: Decodable>(url urlString: String, of type: T.Type) -> Single<T> {
        return Single.create { single -> Disposable in
            guard let url = URL(string: urlString) else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    single(.failure(NetworkError.unknown))
                    print(error.localizedDescription)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    single(.failure(NetworkError.status))
                    return
                }
                
                if let data {
                    do {
                        let appData = try JSONDecoder().decode(T.self, from: data)
                        single(.success(appData))
                    } catch {
                        single(.failure(NetworkError.decoding))
                        print(error)
                    }
                } else {
                    single(.failure(NetworkError.noData))
                }
            }.resume()
            
            return Disposables.create()
        }.debug("API 요청 \(String(describing: T.self))")
    }
}
