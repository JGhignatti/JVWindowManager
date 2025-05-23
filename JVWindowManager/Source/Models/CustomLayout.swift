//
//  CustomLayout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 24/04/25.
//

import Defaults
import Foundation
import KeyboardShortcuts

struct CustomLayout {
    let id: UUID
    let name: String
    let insetRect: InsetRect
    
    var keyboardShortcutsName: KeyboardShortcuts.Name {
        .init(id.uuidString)
    }
}

extension CustomLayout: Defaults.Serializable {
    static let bridge = CustomLayoutBridge()
}

extension CustomLayout: Identifiable, Codable, Equatable, Hashable {}

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
