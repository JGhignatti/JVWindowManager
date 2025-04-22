//
//  KeyCombo.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 20/04/25.
//

import AppKit
import HotKey

struct KeyCombo: Codable {
    var key: Key
    var modifiers: NSEvent.ModifierFlags
}
