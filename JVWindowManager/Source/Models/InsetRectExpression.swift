//
//  InsetRectExpression.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 20/04/25.
//

import Expression
import Foundation

struct InsetRectExpression: Codable {
    var top: String
    var bottom: String
    var left: String
    var right: String

    init(_ amount: String) {
        self.init(top: amount, bottom: amount, left: amount, right: amount)
    }

    init(dx: String, dy: String) {
        self.init(top: dy, bottom: dy, left: dx, right: dx)
    }

    init(top: String, bottom: String, left: String, right: String) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }
    
    static func variables(for frame: CGRect) -> [String: Double] {
        let gap = SettingsManager.shared.gapSize
        let halfGap = gap / 2
        let stageManager = SettingsManager.shared.stageManagerSize
        let peekSize = SettingsManager.shared.peekSize

        let variables: [String: Double] = [
            "width": Double(frame.width),
            "height": Double(frame.height),
            "gap": Double(gap),
            "halfGap": Double(halfGap),
            "stageManager": Double(stageManager),
            "peek": Double(peekSize),
        ]
        
        return variables
    }

    func evaluate(for frame: CGRect) throws -> CGRect {
        let gap = SettingsManager.shared.gapSize
        let halfGap = gap / 2
        let stageManager = SettingsManager.shared.stageManagerSize
        let peekSize = SettingsManager.shared.peekSize

        let variables: [String: Double] = [
            "width": Double(frame.width),
            "height": Double(frame.height),
            "gap": Double(gap),
            "halfGap": Double(halfGap),
            "stageManager": Double(stageManager),
            "peek": Double(peekSize),
        ]

        func eval(_ expression: String) throws -> CGFloat {
            let exp = Expression(expression, constants: variables)
            return CGFloat(try exp.evaluate())
        }

        let insetTop = try eval(top)
        let insetBottom = try eval(bottom)
        let insetLeft = try eval(left)
        let insetRight = try eval(right)

        return frame.insetBy(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft
        )
    }
}
