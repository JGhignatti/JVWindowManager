//
//  LayoutShortcut.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 20/04/25.
//

import Foundation

struct LayoutShortcut: Identifiable, Codable {
    var id = UUID()
    
    var name: String
    var keyCombo: KeyCombo
    var insetRectExpression: InsetRectExpression
    var enabled: Bool

    init(
        name: String,
        keyCombo: KeyCombo,
        insetRectExpression: InsetRectExpression,
        enabled: Bool = true
    ) {
        self.name = name
        self.keyCombo = keyCombo
        self.insetRectExpression = insetRectExpression
        self.enabled = enabled
    }
}
