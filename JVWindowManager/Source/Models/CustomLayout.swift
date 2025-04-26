//
//  CustomLayout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 24/04/25.
//

import Defaults
import Foundation
import KeyboardShortcuts

struct CustomLayout: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let insetRect: InsetRect
    
    var keyboardShortcutsName: KeyboardShortcuts.Name {
        .init(id.uuidString)
    }

    init(
        id: UUID,
        name: String,
        insetRect: InsetRect
    ) {
        self.id = id
        self.name = name
        self.insetRect = insetRect
    }
}

extension CustomLayout: Defaults.Serializable {
    static let bridge = CustomLayoutBridge()
}

struct CustomLayoutBridge: Defaults.Bridge {
    typealias Value = CustomLayout
    typealias Serializable = Data

    func serialize(_ value: Value?) -> Serializable? {
        guard let value else { return nil }

        do {
            return try JSONEncoder().encode(value)
        } catch {
            return nil
        }
    }

    func deserialize(_ object: Serializable?) -> Value? {
        guard let object else { return nil }

        do {
            return try JSONDecoder().decode(Value.self, from: object)
        } catch {
            return nil
        }
    }
}
