//
//  EvaluatableRect.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 28/04/25.
//

import Expression
import Foundation

protocol EvaluatableRect {
    static func constants(for frame: CGRect) -> [String: Double]

    var valid: Bool { get }

    func evaluate(for frame: CGRect) throws -> CGRect
}

extension EvaluatableRect {
    func eval(_ expression: String, with constants: [String: Double]) throws
        -> CGFloat
    {
        let exp = Expression(expression, constants: constants)

        return CGFloat(try exp.evaluate())
    }
}
