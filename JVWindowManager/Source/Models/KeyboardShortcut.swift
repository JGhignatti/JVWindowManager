//
//  KeyboardShortcut.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/04/25.
//

import AppKit
import HotKey

struct KeyboardShortcut: Equatable, Codable, Hashable {
    var key: Key
    var modifiers: NSEvent.ModifierFlags

    init(key: Key, modifiers: NSEvent.ModifierFlags) {
        self.key = key
        self.modifiers = modifiers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(Key.self, forKey: .key)
        let rawModifiers = try container.decode(UInt.self, forKey: .modifiers)
        modifiers = NSEvent.ModifierFlags(rawValue: rawModifiers)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(modifiers.rawValue, forKey: .modifiers)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(modifiers.rawValue)
    }

    static func == (lhs: KeyboardShortcut, rhs: KeyboardShortcut) -> Bool {
        lhs.key == rhs.key && lhs.modifiers.rawValue == rhs.modifiers.rawValue
    }

    enum CodingKeys: String, CodingKey {
        case key
        case modifiers
    }
}
