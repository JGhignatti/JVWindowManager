//
//  CGRectX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import CoreGraphics

extension CGRect {
    func insetBy(_ amount: CGFloat) -> CGRect {
        return insetBy(dx: amount, dy: amount)
    }

    func insetBy(
        top: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0,
        left: CGFloat = 0
    ) -> CGRect {
        return CGRect(
            x: self.origin.x + left,
            y: self.origin.y + top,
            width: self.width - left - right,
            height: self.height - top - bottom
        )
    }
}
