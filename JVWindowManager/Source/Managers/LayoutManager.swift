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
            // No frontmost app found
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
        guard let windowElement = windowElement, let screen = NSScreen.main
        else {
            return
        }

        let screenFrame = screen.visibleFrameAXCompatible
        var finalRect = layout.inset(from: screenFrame)

        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgPoint, &finalRect.origin)!,
            for: .position
        )
        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgSize, &finalRect.size)!,
            for: .size
        )
    }
}
