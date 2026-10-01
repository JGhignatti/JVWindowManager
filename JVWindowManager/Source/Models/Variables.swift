//
//  Variables.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 12/08/25.
//

import Defaults
import Foundation

struct Variables {
    static let `default`: Variables = .init(
        padding: 16,
        gap: 16,
        stageManager: 180,
        step: 8
    )

    var padding: Int
    var gap: Int
    var stageManager: Int
    var step: Int
}

extension Variables: Defaults.Serializable {
    static let bridge = VariablesBridge()
}

struct VariablesBridge: Defaults.Bridge {
    typealias Value = Variables
    typealias Serializable = [String: Int]

    func serialize(_ value: Value?) -> Serializable? {
        guard let value else {
            return nil
        }

        return [
            CodingKeys.padding.rawValue: value.padding,
            CodingKeys.gap.rawValue: value.gap,
            CodingKeys.stageManager.rawValue: value.stageManager,
            CodingKeys.step.rawValue: value.step,
        ]
    }

    func deserialize(_ object: Serializable?) -> Value? {
        guard let object else {
            return nil
        }

        return Variables(
            padding: object[CodingKeys.padding.rawValue]
                ?? Variables.default.padding,
            gap: object[CodingKeys.gap.rawValue] ?? Variables.default.gap,
            stageManager: object[CodingKeys.stageManager.rawValue]
                ?? Variables.default.stageManager,
            step: object[CodingKeys.step.rawValue] ?? Variables.default.step
        )
    }

    enum CodingKeys: String {
        case padding, gap, stageManager, step
    }
}
