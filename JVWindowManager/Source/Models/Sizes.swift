//
//  Sizes.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults

struct Sizes {
    var padding: Int
    var gap: Int
    var stageManager: Int
    var peek: Int
}

extension Sizes: Defaults.Serializable {
    static let bridge = SizesBridge()
}

struct SizesBridge: Defaults.Bridge {
    typealias Value = Sizes
    typealias Serializable = [String: Int]

    func serialize(_ value: Sizes?) -> [String: Int]? {
        guard let value else {
            return nil
        }

        return [
            SizesKey.padding.rawValue: value.padding,
            SizesKey.gap.rawValue: value.gap,
            SizesKey.stageManager.rawValue: value.stageManager,
            SizesKey.peek.rawValue: value.peek,
        ]
    }

    func deserialize(_ object: [String: Int]?) -> Sizes? {
        guard
            let object,
            let padding = object[SizesKey.padding.rawValue],
            let gap = object[SizesKey.gap.rawValue],
            let stageManager = object[SizesKey.stageManager.rawValue],
            let peek = object[SizesKey.peek.rawValue]
        else {
            return nil
        }

        return Sizes(
            padding: padding,
            gap: gap,
            stageManager: stageManager,
            peek: peek
        )
    }
}

private enum SizesKey: String {
    case padding, gap, stageManager, peek
}
