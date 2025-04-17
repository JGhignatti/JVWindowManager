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

    var defaultLayoutShortcutPairs: [LayoutShortcutPair] {
        get {
            if let data = defaults.data(
                forKey: SettingKey.defaultLayoutShortcutPairs
            ),
                let decoded = try? JSONDecoder().decode(
                    [LayoutShortcutPair].self,
                    from: data
                )
            {
                return decoded
            }

            return Layout.allCases.map {
                .init(layout: $0, shortcut: $0.defaultShortcut)
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: SettingKey.defaultLayoutShortcutPairs)
                
                HotKeysManager.shared.registerAll()
            }
        }
    }
}
