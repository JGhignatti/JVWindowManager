//
//  HotKeysManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import HotKey

final class HotKeysManager {
    static let shared = HotKeysManager()

    private var hotKeys: [HotKey] = []

    private init() {}

    func registerAll() {
        hotKeys.removeAll()

        hotKeys =
            SettingsManager.shared.layoutShortcuts
            .filter { $0.enabled }
            .map {
                let insetRectExpression = $0.insetRectExpression
                let hotKey = HotKey(
                    key: $0.keyCombo.key,
                    modifiers: $0.keyCombo.modifiers
                )
                hotKey.keyDownHandler = {
                    LayoutManager.shared.trigger(insetRectExpression)
                }

                return hotKey
            }
    }
}
