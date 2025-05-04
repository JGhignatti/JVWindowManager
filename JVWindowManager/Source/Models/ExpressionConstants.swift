//
//  ExpressionConstants.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 28/04/25.
//

import Defaults
import Foundation

enum ExpressionConstants {
    enum Key: String, CaseIterable {
        case width, height, originX, originY, padding, gap, halfGap, stageManager, peek, step
    }

    static func width(for frame: CGRect = .zero) -> Double {
        frame.width
    }

    static func height(for frame: CGRect = .zero) -> Double {
        frame.height
    }
    
    static func originX(for frame: CGRect = .zero) -> Double {
        frame.origin.x
    }
    
    static func originY(for frame: CGRect = .zero) -> Double {
        frame.origin.y
    }

    static var padding: Double {
        Double(Defaults[.sizes].padding)
    }

    static var gap: Double {
        Double(Defaults[.sizes].gap)
    }
    
    static var halfGap: Double {
        gap / 2
    }

    static var stageManager: Double {
        Double(Defaults[.sizes].stageManager)
    }

    static var peek: Double {
        Double(Defaults[.sizes].peek)
    }

    static var step: Double {
        Double(Defaults[.sizes].step)
    }

    static func all(keeping keepKeys: Set<Key> = [], frame: CGRect = .zero)
        -> [String: Double]
    {
        Dictionary(
            uniqueKeysWithValues: Key.allCases
                .filter { keepKeys.contains($0) }
                .map { key in
                    (key.rawValue, value(for: key, frame: frame))
                }
        )
    }

    static func value(for key: Key, frame: CGRect) -> Double {
        switch key {
        case .width:
            return width(for: frame)
        case .height:
            return height(for: frame)
        case .originX:
            return originX(for: frame)
        case .originY:
            return originY(for: frame)
        case .padding:
            return padding
        case .gap:
            return gap
        case .halfGap:
            return halfGap
        case .stageManager:
            return stageManager
        case .peek:
            return peek
        case .step:
            return step
        }
    }
}
