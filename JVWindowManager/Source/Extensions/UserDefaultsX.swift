//
//  UserDefaultsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import Foundation

extension UserDefaults {
    func integer(forKey key: String, default defaultValue: Int) -> Int {
        if object(forKey: key) != nil {
            return integer(forKey: key)
        } else {
            return defaultValue
        }
    }

    func decode<T>(forKey key: String, default defaultValue: T) -> T
    where T: Codable {
        if let data = data(forKey: key),
            let decoded = try? JSONDecoder().decode(T.self, from: data)
        {
            return decoded
        }

        return defaultValue
    }
    
    func encode(_ value: Codable, forKey key: String, perform action: (() -> Void)? = nil) {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: key)
            
            action?()
        }
    }
}
