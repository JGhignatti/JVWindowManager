//
//  SettingsManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import Foundation

final class SettingsManager {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    private init() {}

    var gapSize: Int {
        get {
            return defaults.integer(forKey: SettingKey.gapSize, default: 16)
        }
        set {
            if newValue >= 0 {
                defaults.set(newValue, forKey: SettingKey.gapSize)
            }
        }
    }

    var stageManagerSize: Int {
        get {
            return defaults.integer(
                forKey: SettingKey.stageManagerSize,
                default: 180
            )
        }
        set {
            if newValue >= 0 {
                defaults.set(newValue, forKey: SettingKey.stageManagerSize)
            }
        }
    }

    var peekSize: Int {
        get {
            return defaults.integer(forKey: SettingKey.peekSize, default: 48)
        }
        set {
            if newValue >= 0 {
                defaults.set(newValue, forKey: SettingKey.peekSize)
            }
        }
    }
}
