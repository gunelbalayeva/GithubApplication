//
//  NetworkService.swift
//  GithubApplication
//
//  Created by User on 17.05.25.
//

import Foundation

protocol NetworkService {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class URLSessionNetworkService: NetworkService {
    
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task =  URLSession.shared.dataTask(with: url) { data, resp, err in
            if let e = err {
                completion(.failure(e)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain:"DataNil", code:0)))
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(obj))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
