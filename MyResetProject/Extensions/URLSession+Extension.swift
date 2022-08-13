//
//  URLSession+Extension.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import Foundation

import Foundation

extension URLSession {
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: handler)
        task.resume()
        return task
    }
    
    static func requestResultType<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (Result<T, NaverSearchError>) -> ()) {
        
        session.dataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(.failure((.failed)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure((.noData)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure((.invalidResponse)))
                    return
                }
                
                print(response)
                
                guard response.statusCode == 200 else {
                    completion(.failure(NaverSearchError(rawValue: response.statusCode) ?? .unknown))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure((.invalidData)))
                }
            }
        }.resume()
    }
    
    
    static func requestDelegate(_ session: URLSession, endpoint: URLRequest) {
        session.dataTask(with: endpoint).resume()
    }
    
    static func requestDelegateHandler<T: Codable>(_ session: URLSession, endpoint: URLRequest, completion: @escaping (Result<T, NaverSearchError>) -> ()) {
        session.dataTask(with: endpoint) { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(.failure((.failed)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure((.noData)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure((.invalidResponse)))
                    return
                }
                
                
                guard response.statusCode == 200 else {
                    completion(.failure(NaverSearchError(rawValue: response.statusCode) ?? .unknown))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = try decoder.decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure((.invalidData)))
                }
            }
        }.resume()
    }


}
