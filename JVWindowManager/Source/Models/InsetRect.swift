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
    
    private static var validationConstants: [String: Double] { constants() }
    var topValid: Bool {
        return (try? eval(top, with: Self.validationConstants)) != nil
    }
    var bottomValid: Bool {
        return (try? eval(bottom, with: Self.validationConstants)) != nil
    }
    var leftValid: Bool {
        return (try? eval(left, with: Self.validationConstants)) != nil
    }
    var rightValid: Bool {
        return (try? eval(right, with: Self.validationConstants)) != nil
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
}

extension InsetRect: EvaluatableRect {
    static func constants(for frame: CGRect = .zero) -> [String: Double] {
        ExpressionConstants.all(
            keeping: [
                .width, .height, .padding, .gap, .halfGap, .stageManager, .step
            ],
            frame: frame
        )
    }

    var valid: Bool {
        topValid && bottomValid && leftValid && rightValid
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
