//
//  Layout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 12/08/25.
//

import Defaults
import Foundation
import KeyboardShortcuts

struct Layout: ResizeActor {
    let id: UUID
    let name: String
    let rect: InsetRect

    var keyboardShortcutsName: KeyboardShortcuts.Name {
        .init(id.uuidString)
    }

    @MainActor var shortcut: KeyboardShortcuts.Shortcut? {
        KeyboardShortcuts.getShortcut(for: keyboardShortcutsName)
    }

    @MainActor init(
        id: UUID = UUID(),
        name: String,
        rect: InsetRect,
        shortcut: KeyboardShortcuts.Shortcut? = nil,
    ) {
        self.id = id
        self.name = name
        self.rect = rect

        if shortcut != nil {
            keyboardShortcutsName.shortcut = shortcut
        }
    }
}

extension Layout: Defaults.Serializable {
    static let bridge = LayoutBridge()
}

extension Layout: Codable, Equatable, Hashable {}

struct LayoutBridge: Defaults.Bridge {
    typealias Value = Layout
    typealias Serializable = Data

    func serialize(_ value: Value?) -> Serializable? {
        guard let value else {
            return nil
        }

        do {
            return try JSONEncoder().encode(value)
        } catch {
            return nil
        }
    }

    func deserialize(_ object: Serializable?) -> Value? {
        guard let object else {
            return nil
        }

        do {
            return try JSONDecoder().decode(Value.self, from: object)
        } catch {
            return nil
        }
    }
}

@MainActor func getDefaultLayouts() -> [Layout] {
    return [
        .init(
            name: "Full screen",
            rect: .init("padding"),
            shortcut: .init(.return, modifiers: [.control, .option]),
        ),
        .init(
            name: "Top half",
            rect: .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "padding",
                right: "padding"
            ),
            shortcut: .init(.upArrow, modifiers: [.control, .option]),
        ),
        .init(
            name: "Bottom half",
            rect: .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "padding",
                right: "padding"
            ),
            shortcut: .init(.downArrow, modifiers: [.control, .option]),
        ),
        .init(
            name: "Left half",
            rect: .init(
                top: "padding",
                bottom: "padding",
                left: "padding",
                right: "width / 2 + halfGap"
            ),
            shortcut: .init(.leftArrow, modifiers: [.control, .option]),
        ),
        .init(
            name: "Right half",
            rect: .init(
                top: "padding",
                bottom: "padding",
                left: "width / 2 + halfGap",
                right: "padding"
            ),
            shortcut: .init(.rightArrow, modifiers: [.control, .option]),
        ),
        .init(
            name: "Stage manager full screen",
            rect: .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager",
                right: "padding"
            ),
            shortcut: .init(.return, modifiers: [.control, .option, .shift]),
        ),
    ]
}
