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
}

extension ActionRect: EvaluatableRect {
    var valid: Bool {
        let consts = Self.constants()

        let widthValid = (try? eval(width, with: consts)) != nil
        let heightValid = (try? eval(height, with: consts)) != nil
        let xValid = (try? eval(x, with: consts)) != nil
        let yValid = (try? eval(y, with: consts)) != nil

        return widthValid && heightValid && xValid && yValid
    }

    static func constants(for frame: CGRect = .zero) -> [String: Double] {
        ExpressionConstants.all(
            keeping: [
                .width, .height, .originX, .originY, .padding, .gap, .halfGap,
                .stageManager, .peek, .step,
            ],
            frame: frame
        )
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
