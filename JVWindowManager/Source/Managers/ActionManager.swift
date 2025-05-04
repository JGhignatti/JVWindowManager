//
//  ActionManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 29/04/25.
//

import SwiftUI

final class ActionManager: Triggerable {
    static let shared = ActionManager()

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
    
    private var screensUnionFrame: CGRect {
        NSScreen.screens.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
    }

    private init() {}

    func trigger(_ value: ActionRect) {
        guard AccessibilityPermissionManager.shared.isPermissionGranted,
            let app = NSWorkspace.shared.frontmostApplication
        else {
            return
        }

        withEnhancedUserInterfaceDisabled(for: app) {
            apply(value)
        }
    }

    private func apply(_ actionRect: ActionRect) {
        guard
            let windowElement = windowElement,
            let positionRaw = windowElement.getAttributeValue(for: .position),
            CFGetTypeID(positionRaw) == AXValueGetTypeID(),
            let sizeRaw = windowElement.getAttributeValue(for: .size),
            CFGetTypeID(sizeRaw) == AXValueGetTypeID()
        else {
            return
        }

        var position = CGPoint.zero
        var size = CGSize.zero

        AXValueGetValue(positionRaw as! AXValue, .cgPoint, &position)
        AXValueGetValue(sizeRaw as! AXValue, .cgSize, &size)

        let axFrame = CGRect(origin: position, size: size)
        let windowFrame = axFrame
        
        let targetFrame = try! actionRect.evaluate(for: windowFrame)
        var finalFrame = targetFrame
        
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
