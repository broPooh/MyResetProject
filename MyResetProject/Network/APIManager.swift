//
//  APIManager.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

import Alamofire

import RxSwift
import RxCocoa
import RxAlamofire

final class APIManager {
    private let scheduler: ConcurrentDispatchQueueScheduler
    static let shared = APIManager()
    
    private init() {
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))

    }
        
    func searchMovieSingle(query: String, start: Int) -> Single<MovieResult> {
        return Single<MovieResult>.create { single in
            APIManager.shared.searchMovieSession(query: query, start: start) { result in
                switch result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func searchMovieSession(query: String, start: Int, completion: @escaping (Result<MovieResult, NaverSearchError>) -> ()) {
        let compoenet = makeURLComponents(url: Endpoint.searchMovie.urlString, params: [
            "query": query,
            "start" : "\(start)"
        ])!
        
        let request = makeURLRequestFromComponent(component: compoenet, headers: [
            NetworkHeader.clientId.rawValue : NetworkHeaderField.clientId.field,
            NetworkHeader.clientSecret.rawValue : NetworkHeaderField.clientSecret.field,
        ])
        
        URLSession.requestResultType(endpoint: request, completion: completion)
    }
    
    
    func makeURLComponents(url: String, params: [String: String]) -> URLComponents? {
        guard var component = URLComponents(string: url) else { return nil}
        component.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return component
    }
    
    func makeURLRequestFromComponent(component: URLComponents, method: HTTPMethod = .GET, headers: [String : String]) -> URLRequest {
        var request = URLRequest(url: component.url!)
        request.httpMethod = method.rawValue
        
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
    
        return request
    }
    
}
