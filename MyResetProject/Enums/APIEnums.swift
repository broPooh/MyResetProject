//
//  APIEnums.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation


enum NetworkHeader: String {
    case clientId = "X-Naver-Client-Id"
    case clientSecret = "X-Naver-Client-Secret"
}

enum NetworkHeaderField {
    case clientId
    case clientSecret
    
    var field: String {
        switch self {
        case .clientId: return Config.clientId
        case .clientSecret: return Config.clientSecret
        }
    }
}

enum SearchEnums {
    static let startPage = 1
    static let totalCount = 1
    static let displayCount = 10
    static let throttle = 500
    static let debounce = 1
}


enum NaverSearchError: Int, Error {
    case checkParameter = 400
    case unAuthorization = 401
    case faileRequset = 403
    case notFound = 404
    case methodError = 405
    case validationFailed = 422
    case callLimitError = 429
    case systemError = 500
    case unknown
    case failed
    case invalidResponse
    case noData
    case invalidData

    var description: String { self.errorDescription }
}

extension NaverSearchError {
    var errorDescription: String {
        switch self {
        case .checkParameter: return "400: Parameter Error"
        case .unAuthorization: return "401: Authorization Error"
        case .faileRequset: return "403: Requset Error"
        case .notFound: return "404: Not Found"
        case .methodError: return "405: HTTP Method Error"
        case .validationFailed: return "422: Validation Failed"
        case .callLimitError: return "429: Limit Error"
        case .systemError: return "500: System Error"
        case .failed: return "네트워크통신 실패"
        case .invalidData: return "시리얼라이즈 실패"
        default: return "UN_KNOWN_ERROR"
        }
    }
}
