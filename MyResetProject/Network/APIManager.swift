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
    
    func searchMovie(query: String, start: Int) -> Single<MovieResult> {
        let compoenet = makeURLComponents(url: Endpoint.searchMovie.urlString, params: [
            "query": query,
            "start" : "\(start)"
        ])!
        
        let request = makeURLRequestFromComponent(component: compoenet, headers: [
            NetworkHeader.clientId.rawValue : NetworkHeaderField.clientId.field,
            NetworkHeader.clientSecret.rawValue : NetworkHeaderField.clientSecret.field,
        ])
        
        print("요청됬니?")
        return Single<MovieResult>.create { single in
            RxAlamofire
                .requestData(request)
                .observe(on: self.scheduler)
                .map { response, data in
                    if 200...300 ~= response.statusCode {
                        do {
                            let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
                            print(movieResult)
                            single(.success(movieResult))
                        } catch {
                            print("실패")
                            single(.failure(NaverSearchError.invalidData))
                        }
                    }
                    single(.failure(NaverSearchError.init(rawValue: response.statusCode) ?? NaverSearchError.unknown))
                }
                .asObservable()

            return Disposables.create()
        }
    }
    
    func searchMovieSingle(query: String, start: Int) -> Single<MovieResult> {
        print("요청됬니?")
        return Single<MovieResult>.create { single in
            APIManager.shared.searchMovieSession(query: query, start: start) { result in
                switch result {
                case .success(let result):
                    print("성공")
                    single(.success(result))
                case .failure(let error):
                    print("실패")
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func searchMovieTest2(query: String, start: Int) -> Single<MovieResult> {
        let compoenet = makeURLComponents(url: Endpoint.searchMovie.urlString, params: [
            "query": query,
            "start" : "\(start)"
        ])!
        
        let request = makeURLRequestFromComponent(component: compoenet, headers: [
            NetworkHeader.clientId.rawValue : NetworkHeaderField.clientId.field,
            NetworkHeader.clientSecret.rawValue : NetworkHeaderField.clientSecret.field,
        ])
               
        return RxAlamofire
            .requestData(request)
            .flatMap({ (response, data) -> Observable<MovieResult> in
                if 200...300 ~= response.statusCode {
                    do {
                        let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
                        print(movieResult)
                                                
                        return Observable.just(movieResult)
                    } catch {
                        print("에러")
                        return Observable.error(NaverSearchError.init(rawValue: response.statusCode)!)
                    }
                }
                return Observable.error(NaverSearchError.init(rawValue: response.statusCode) ?? NaverSearchError.unknown)
            })
            .asSingle()
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
