//
//  UserDefaults.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation

extension UserDefaults {
    public struct Key {
        fileprivate let name: String
        public init(_ name: String) {
            self.name = name
        }
    }
    
    public func getValue(for key: Key) -> Any? {
        return object(forKey: key.name)
    }
    
    public func setValue(_ value: Any?, for key: Key) {
        set(value, forKey: key.name)
    }
    
    public func removeValue(for key: Key) {
        removeObject(forKey: key.name)
    }
}

extension UserDefaults.Key {
    static let tokenLogin = UserDefaults.Key("UserService_TokenLogin")
    static let currentPassword = UserDefaults.Key("UserService_CurrentPassword")
}
