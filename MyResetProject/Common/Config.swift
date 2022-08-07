//
//  Config.swift
//  MyResetProject
//
//  Created by bro on 2022/08/06.
//

import Foundation

struct Config {
    private init() { }
    enum PlistKeys: String {
        case clientId = "Client_Id"
        case clientSecret = "Client_Secret"
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
        
    static let clientId: String = {
        guard let clientId = Config.infoDictionary[PlistKeys.clientId.rawValue] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return clientId
    }()
    
    static let clientSecret: String = {
        guard let clientSecret = Config.infoDictionary[PlistKeys.clientSecret.rawValue] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return clientSecret
    }()
}
