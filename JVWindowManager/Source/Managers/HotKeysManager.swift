//
//  HotKeysManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import HotKey

final class HotKeysManager {
    static let shared = HotKeysManager()

    private var hotKeys: [HotKey?] = []

    private init() {}

    func registerAll() {
        hotKeys = Layout.allCases.map {
            $0.hotKey
        }
    }
}
