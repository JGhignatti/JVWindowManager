//
//  InsetRect.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults
import Expression
import Foundation

struct InsetRect {
    static func constants(for frame: CGRect = .zero) -> [String: Double] {
        let gap = Double(Defaults[.sizes].gap)

        let consts: [String: Double] = [
            "width": Double(frame.width),
            "height": Double(frame.height),
            "padding": Double(Defaults[.sizes].padding),
            "gap": gap,
            "halfGap": gap / 2.0,
            "stageManager": Double(Defaults[.sizes].stageManager),
            "peek": Double(Defaults[.sizes].peek),
        ]

        return consts
    }

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

    func evaluate(for frame: CGRect) throws -> CGRect {
        let consts = InsetRect.constants(for: frame)

        func eval(_ expression: String) throws -> CGFloat {
            let exp = Expression(expression, constants: consts)

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
            left: insetLeft,
        )
    }
}
