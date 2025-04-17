//
//  LayoutShortcutPair.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/04/25.
//

struct LayoutShortcutPair: Codable, Equatable, Hashable {
    var layout: Layout
    var shortcut: KeyboardShortcut?
}
