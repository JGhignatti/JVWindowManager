//
//  Action.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/05/26.
//

import Defaults
import Foundation
import KeyboardShortcuts

struct Action: ResizeActor {
    let id: UUID
    let name: String
    let rect: ActionRect
    var repeatBehavior: ActionRepeat
    var bounds: ActionBounds

    var keyboardShortcutsName: KeyboardShortcuts.Name {
        .init(id.uuidString)
    }

    @MainActor var shortcut: KeyboardShortcuts.Shortcut? {
        KeyboardShortcuts.getShortcut(for: keyboardShortcutsName)
    }

    @MainActor init(
        id: UUID = UUID(),
        name: String,
        rect: ActionRect,
        repeatBehavior: ActionRepeat = .default,
        bounds: ActionBounds = .default,
        shortcut: KeyboardShortcuts.Shortcut? = nil,
    ) {
        self.id = id
        self.name = name
        self.rect = rect
        self.repeatBehavior = repeatBehavior
        self.bounds = bounds

        if shortcut != nil {
            keyboardShortcutsName.shortcut = shortcut
        }
    }
}

extension Action: Defaults.Serializable {
    static let bridge = ActionBridge()
}

extension Action: Equatable, Hashable {}

extension Action: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, rect, repeatBehavior, bounds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rect = try container.decode(ActionRect.self, forKey: .rect)
        // Falls back to the defaults for actions stored before these fields existed.
        repeatBehavior =
            try container.decodeIfPresent(ActionRepeat.self, forKey: .repeatBehavior)
            ?? .default
        bounds =
            try container.decodeIfPresent(ActionBounds.self, forKey: .bounds) ?? .default
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(rect, forKey: .rect)
        try container.encode(repeatBehavior, forKey: .repeatBehavior)
        try container.encode(bounds, forKey: .bounds)
    }
}

struct ActionBridge: Defaults.Bridge {
    typealias Value = Action
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

@MainActor func getDefaultActions() -> [Action] {
    return [
        .init(
            name: "+ All sides",
            rect: .init(
                width: "width + step",
                height: "height + step",
                x: "originX - (step / 2)",
                y: "originY - (step / 2)"
            ),
            shortcut: .init(.equal, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "+ Horizontal",
            rect: .init(
                width: "width + step",
                height: "height",
                x: "originX - (step / 2)",
                y: "originY"
            ),
            shortcut: .init(.d, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "+ Vertical",
            rect: .init(
                width: "width",
                height: "height + step",
                x: "originX",
                y: "originY - (step / 2)"
            ),
            shortcut: .init(.w, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "- All sides",
            rect: .init(
                width: "width - step",
                height: "height - step",
                x: "originX + (step / 2)",
                y: "originY + (step / 2)"
            ),
            shortcut: .init(.minus, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "- Horizontal",
            rect: .init(
                width: "width - step",
                height: "height",
                x: "originX + (step / 2)",
                y: "originY"
            ),
            shortcut: .init(.a, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "- Vertical",
            rect: .init(
                width: "width",
                height: "height - step",
                x: "originX",
                y: "originY + (step / 2)"
            ),
            shortcut: .init(.s, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "Move up",
            rect: .init(
                width: "width",
                height: "height",
                x: "originX",
                y: "originY - step"
            ),
            shortcut: .init(.upArrow, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "Move down",
            rect: .init(
                width: "width",
                height: "height",
                x: "originX",
                y: "originY + step"
            ),
            shortcut: .init(.downArrow, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "Move left",
            rect: .init(
                width: "width",
                height: "height",
                x: "originX - step",
                y: "originY",
            ),
            shortcut: .init(.leftArrow, modifiers: [.control, .option, .command]),
        ),
        .init(
            name: "Move right",
            rect: .init(
                width: "width",
                height: "height",
                x: "originX + step",
                y: "originY",
            ),
            shortcut: .init(.rightArrow, modifiers: [.control, .option, .command]),
        ),
    ]
}
