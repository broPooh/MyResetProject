//
//  UserDefaultWapper.swift
//  MyResetProject
//
//  Created by bro on 2022/08/14.
//

import Foundation

@propertyWrapper
struct UserDefaultWapper<T> {
        
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
       
    }
}



class UserDefaultManager {
    
    @UserDefaultWapper(key: "usesTouchID", defaultValue: false, storage: .standard)
    static var usesTouchID: Bool

    @UserDefaultWapper(key: "myEmail", defaultValue: nil, storage: .standard)
    static var myEmail: String?
    
    @UserDefaultWapper(key: "isLoggedIn", defaultValue: false, storage: .standard)
    static var isLoggedIn: Bool

}
