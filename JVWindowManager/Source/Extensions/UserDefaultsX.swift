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
}
