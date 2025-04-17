//
//  ModifierFlagsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/04/25.
//

import AppKit

extension NSEvent.ModifierFlags {
    var displaySymbols: String {
        var symbols = ""

        if contains(.shift) {
            symbols += "⇧"
        }
        if contains(.control) {
            symbols += "⌃"
        }
        if contains(.option) {
            symbols += "⌥"
        }
        if contains(.command) {
            symbols += "⌘"
        }

        return symbols
    }
}
