//
//  InsetRect.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults
import Expression
import Foundation

struct InsetRect: Codable, Equatable, Hashable {
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

    var valid: Bool {
        let consts = InsetRect.constants()
        
        let topValid = (try? eval(top, consts)) != nil
        let bottomValid = (try? eval(bottom, consts)) != nil
        let leftValid = (try? eval(left, consts)) != nil
        let rightValid = (try? eval(right, consts)) != nil
        
        return topValid && bottomValid && leftValid && rightValid
    }

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

        let insetTop = try eval(top, consts)
        let insetBottom = try eval(bottom, consts)
        let insetLeft = try eval(left, consts)
        let insetRight = try eval(right, consts)

        return frame.insetBy(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft,
        )
    }

    private func eval(_ expression: String, _ constants: [String: Double])
        throws -> CGFloat
    {
        let exp = Expression(expression, constants: constants)
        
        return CGFloat(try exp.evaluate())
    }
}
