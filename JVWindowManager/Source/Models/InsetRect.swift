//
//  InsetRect.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Expression
import Foundation

struct InsetRect {
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
}

extension InsetRect: EvaluatableRect {
    var valid: Bool {
        let consts = Self.constants()

        let topValid = (try? eval(top, with: consts)) != nil
        let bottomValid = (try? eval(bottom, with: consts)) != nil
        let leftValid = (try? eval(left, with: consts)) != nil
        let rightValid = (try? eval(right, with: consts)) != nil

        return topValid && bottomValid && leftValid && rightValid
    }

    static func constants(for frame: CGRect = .zero) -> [String: Double] {
        ExpressionConstants.all(
            keeping: [
                .width, .height, .padding, .gap, .halfGap, .stageManager, .peek,
            ],
            frame: frame
        )
    }

    func evaluate(for frame: CGRect) throws -> CGRect {
        let consts = Self.constants(for: frame)

        let insetTop = try eval(top, with: consts)
        let insetBottom = try eval(bottom, with: consts)
        let insetLeft = try eval(left, with: consts)
        let insetRight = try eval(right, with: consts)

        return frame.insetBy(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft,
        )
    }
}

extension InsetRect: Codable, Equatable, Hashable {}
