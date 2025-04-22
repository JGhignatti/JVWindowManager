//
//  SettingsManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import AppKit
import HotKey

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

    var layoutShortcuts: [LayoutShortcut] {
        get {
            defaults.decode(
                forKey: SettingKey.layoutShortcuts,
                default: Layout.allCases.map { $0.defaultLayoutShortcut }
            )
        }
        set {
            defaults.encode(newValue, forKey: SettingKey.layoutShortcuts) {
                HotKeysManager.shared.registerAll()
            }
        }
    }
    
    var customLayoutShortcuts: [LayoutShortcut] {
        get {
            defaults.decode(
                forKey: SettingKey.customLayoutShortcuts,
                default: []
            )
        }
        set {
            defaults.encode(newValue, forKey: SettingKey.customLayoutShortcuts) {
                // TODO: maybe separate in `registerAll` and `registerAllCustoms`
//                HotKeysManager.shared.registerAll()
            }
        }
    }
}
