//
//  URL+Extension.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import Foundation

extension URL {
    static let baseURL = "https://openapi.naver.com/"

    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}

