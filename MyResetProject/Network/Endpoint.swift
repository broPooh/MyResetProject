//
//  Endpoint.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation


enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

enum Endpoint {
    case searchBook
    case searchMovie
}

extension Endpoint {
    var urlString: String {
        switch self {
        case .searchBook: return URL.makeEndPointString("v1/search/book.json")
        case .searchMovie: return URL.makeEndPointString("v1/search/movie.json")
        }
    }
}
