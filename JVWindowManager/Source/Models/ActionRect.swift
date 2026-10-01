//
//  ActionRect.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 28/04/25.
//

import Expression
import Foundation

struct ActionRect {
    var width: String
    var height: String
    var x: String
    var y: String

    private static var validationConstants: [String: Double] { constants() }
    var widthValid: Bool {
        return (try? eval(width, with: Self.validationConstants)) != nil
    }
    var heightValid: Bool {
        return (try? eval(height, with: Self.validationConstants)) != nil
    }
    var xValid: Bool {
        return (try? eval(x, with: Self.validationConstants)) != nil
    }
    var yValid: Bool {
        return (try? eval(y, with: Self.validationConstants)) != nil
    }

    init(width: String, height: String, x: String, y: String) {
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
}

extension ActionRect: EvaluatableRect {
    static func constants(for frame: CGRect = .zero) -> [String: Double] {
        ExpressionConstants.all(
            keeping: [
                .width, .height, .originX, .originY, .padding, .gap, .halfGap,
                .stageManager, .step,
            ],
            frame: frame
        )
    }

    var valid: Bool {
        widthValid && heightValid && xValid && yValid
    }

    func evaluate(for frame: CGRect) throws -> CGRect {
        let consts = Self.constants(for: frame)

        let newWidth = try eval(width, with: consts)
        let newHeight = try eval(height, with: consts)
        let newX = try eval(x, with: consts)
        let newY = try eval(y, with: consts)

        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}

extension ActionRect: Codable, Equatable, Hashable {}
