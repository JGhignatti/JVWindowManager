//
//  Sizes.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults
import Foundation

struct Sizes {
    static var `default`: Sizes {
        return .init(
            padding: 16,
            gap: 16,
            stageManager: 180,
            peek: 80,
            step: 16
        )
    }

    var padding: Int
    var gap: Int
    var stageManager: Int
    var peek: Int
    var step: Int
}

extension Sizes: Defaults.Serializable {
    static let bridge = SizesBridge()
}

struct SizesBridge: Defaults.Bridge {
    typealias Value = Sizes
    typealias Serializable = [String: Int]

    func serialize(_ value: Value?) -> Serializable? {
        guard let value else {
            return nil
        }

        return [
            CodingKeys.padding.rawValue: value.padding,
            CodingKeys.gap.rawValue: value.gap,
            CodingKeys.stageManager.rawValue: value.stageManager,
            CodingKeys.peek.rawValue: value.peek,
            CodingKeys.step.rawValue: value.step,
        ]
    }

    func deserialize(_ object: Serializable?) -> Value? {
        guard let object else {
            return nil
        }

        return Sizes(
            padding: object[CodingKeys.padding.rawValue]
                ?? Sizes.default.padding,
            gap: object[CodingKeys.gap.rawValue] ?? Sizes.default.gap,
            stageManager: object[CodingKeys.stageManager.rawValue]
                ?? Sizes.default.stageManager,
            peek: object[CodingKeys.peek.rawValue] ?? Sizes.default.peek,
            step: object[CodingKeys.step.rawValue] ?? Sizes.default.step
        )
    }

    enum CodingKeys: String {
        case padding, gap, stageManager, peek, step
    }
}
