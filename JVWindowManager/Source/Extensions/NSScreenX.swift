//
//  NSScreenX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import AppKit

extension NSScreen {
    var visibleFrameAXCompatible: CGRect {
        CGRect(
            origin: CGPoint(
                x: visibleFrame.origin.x,
                y: frame.maxY - visibleFrame.maxY
            ),
            size: visibleFrame.size
        )
    }
}
