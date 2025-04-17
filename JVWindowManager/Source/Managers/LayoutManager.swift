//
//  LayoutManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

final class LayoutManager {
    static let shared = LayoutManager()

    private var windowElement: AXUIElement? {
        guard let app = NSWorkspace.shared.frontmostApplication else {
            return nil
        }
        let appElement = AXUIElementCreateApplication(app.processIdentifier)

        guard let rawWindow = appElement.getAttributeValue(for: .focusedWindow)
        else {
            return nil
        }

        let window = unsafeBitCast(rawWindow, to: AXUIElement.self)

        return window
    }

    private var screen: NSScreen? {
        guard
            let window = windowElement,
            let positionRaw = window.getAttributeValue(for: .position),
            CFGetTypeID(positionRaw) == AXValueGetTypeID(),
            let sizeRaw = window.getAttributeValue(for: .size),
            CFGetTypeID(sizeRaw) == AXValueGetTypeID()
        else {
            return nil
        }

        var position = CGPoint.zero
        var size = CGSize.zero

        AXValueGetValue(positionRaw as! AXValue, .cgPoint, &position)
        AXValueGetValue(sizeRaw as! AXValue, .cgSize, &size)

        let axFrame = CGRect(origin: position, size: size)
        let windowFrame = flipAXFrameToNSScreenCoordinates(axFrame)

        return NSScreen.screens.max(by: { a, b in
            a.visibleFrame.intersection(windowFrame).area
                < b.visibleFrame.intersection(windowFrame).area
        })
    }

    private var screensUnionFrame: CGRect {
        NSScreen.screens.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
    }

    private init() {}

    func trigger(_ layout: Layout) {
        guard AccessibilityPermissionManager.shared.isPermissionGranted,
            let app = NSWorkspace.shared.frontmostApplication
        else {
            return
        }

        withEnhancedUserInterfaceDisabled(for: app) {
            applyLayout(layout)
        }
    }

    private func applyLayout(_ layout: Layout) {
        guard let windowElement = windowElement, let screen = screen
        else {
            return
        }

        let targetFrame = layout.inset(from: screen.visibleFrame)
        var finalFrame = flipCGRectToAXCoordinates(targetFrame)

        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgPoint, &finalFrame.origin)!,
            for: .position
        )
        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgSize, &finalFrame.size)!,
            for: .size
        )
    }

    private func flipAXFrameToNSScreenCoordinates(_ axFrame: CGRect) -> CGRect {
        let unionFrame = screensUnionFrame

        var flipped = axFrame
        flipped.origin.y = unionFrame.maxY - axFrame.origin.y - axFrame.height

        return flipped
    }

    private func flipCGRectToAXCoordinates(_ rect: CGRect) -> CGRect {
        let unionFrame = screensUnionFrame

        var flipped = rect
        flipped.origin.y = unionFrame.maxY - rect.origin.y - rect.height
        return flipped
    }
}
