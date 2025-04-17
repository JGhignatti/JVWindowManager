//
//  HotKeysManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import HotKey

final class HotKeysManager {
    static let shared = HotKeysManager()

    private var hotKeys: [Layout: HotKey] = [:]

    private init() {}

    func registerAll() {
        unregisterAll()

        let layoutShortcutPairs = SettingsManager.shared
            .defaultLayoutShortcutPairs

        for pair in layoutShortcutPairs {
            guard let shortcut = pair.shortcut else { continue }

            register(shortcut, for: pair.layout) {
                LayoutManager.shared.trigger(pair.layout)
            }
        }
    }

    private func register(
        _ shortcut: KeyboardShortcut,
        for layout: Layout,
        handler: @escaping () -> Void
    ) {
        unregister(layout)

        let hotKey = HotKey(key: shortcut.key, modifiers: shortcut.modifiers)
        hotKey.keyDownHandler = handler

        hotKeys[layout] = hotKey
    }

    private func unregister(_ layout: Layout) {
        hotKeys[layout] = nil
    }

    private func unregisterAll() {
        hotKeys.removeAll()
    }
}
