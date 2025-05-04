//
//  CustomAction.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/04/25.
//

import Defaults
import Foundation
import KeyboardShortcuts

struct CustomAction {
    let id: UUID
    let name: String
    let actionRect: ActionRect

    var keyboardShortcutsName: KeyboardShortcuts.Name {
        .init(id.uuidString)
    }
}

extension CustomAction: Defaults.Serializable {
    static let bridge = CustomActionBridge()
}

extension CustomAction: Identifiable, Codable, Equatable, Hashable {}

struct CustomActionBridge: Defaults.Bridge {
    typealias Value = CustomAction
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
