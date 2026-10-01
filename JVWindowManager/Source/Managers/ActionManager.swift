//
//  ActionManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 29/04/25.
//

import SwiftUI

@MainActor
final class ActionManager {
    static let shared = ActionManager()

    /// The minimum width and height of a window's frame, in points, that ``ActionBounds/keepVisible``
    /// keeps reachable on some screen.
    private static let grabMargin: CGFloat = 40

    private var windowElement: AXUIElement? {
        guard let app = NSWorkspace.shared.frontmostApplication else {
            return nil
        }
        let appElement = AXUIElementCreateApplication(app.processIdentifier)

        guard let rawWindow = appElement.getAttributeValue(for: .focusedWindow)
        else {
            return nil
        }

        let window = unsafeDowncast(rawWindow, to: AXUIElement.self)

        return window
    }

    /// The union, in AX coordinates (top-left origin, Y growing downward), of every connected
    /// screen's full frame. Used as the reference for flipping AppKit's bottom-left frames.
    private var screensUnionFrame: CGRect {
        NSScreen.screens.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
    }

    private init() {}

    func trigger(_ action: Action) {
        guard AccessibilityPermissionManager.shared.isPermissionGranted else {
            AccessibilityPermissionManager.shared.requestPermission()
            return
        }

        guard let app = NSWorkspace.shared.frontmostApplication else {
            return
        }

        withEnhancedUserInterfaceDisabled(for: app) {
            apply(action)
        }
    }

    private func apply(_ action: Action) {
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

        let currentFrame = CGRect(origin: position, size: size)

        guard let evaluated = try? action.rect.evaluate(for: currentFrame),
            evaluated.width.isFinite, evaluated.height.isFinite,
            evaluated.origin.x.isFinite, evaluated.origin.y.isFinite,
            evaluated.width > 0, evaluated.height > 0
        else {
            return
        }

        var finalFrame = clamp(evaluated, currentFrame: currentFrame, bounds: action.bounds)

        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgPoint, &finalFrame.origin)!,
            for: .position
        )
        let _ = windowElement.setAttributeValue(
            AXValueCreate(.cgSize, &finalFrame.size)!,
            for: .size
        )
    }

    /// Applies `bounds`' safety rule to `target`, an already-evaluated frame in AX coordinates.
    /// `currentFrame`, also in AX coordinates, is the window's frame before this action, used to
    /// find which screen it currently sits on.
    private func clamp(
        _ target: CGRect,
        currentFrame: CGRect,
        bounds: ActionBounds
    ) -> CGRect {
        switch bounds {
        case .none:
            return target

        case .keepVisible:
            return clampKeepingVisible(target, currentFrame: currentFrame)

        case .allScreens:
            return clampToAllScreens(target)

        case .currentScreen:
            return clampToCurrentScreen(target, currentFrame: currentFrame)
        }
    }

    /// Lets `target` hang off any edge, or move to another display, as long as at least
    /// ``grabMargin`` points of its top edge stay over some screen.
    private func clampKeepingVisible(_ target: CGRect, currentFrame: CGRect) -> CGRect {
        let thresholdWidth = min(Self.grabMargin, target.width)
        let thresholdHeight = min(Self.grabMargin, target.height)

        let titleStrip = CGRect(
            x: target.origin.x,
            y: target.origin.y,
            width: target.width,
            height: thresholdHeight
        )

        let screens = axScreenFrames(visible: false)

        let alreadyGrabbable = screens.contains { screen in
            let overlap = screen.intersection(titleStrip)
            return overlap.width >= thresholdWidth && overlap.height >= thresholdHeight
        }

        if alreadyGrabbable {
            return target
        }

        guard
            let anchorScreen = screens.max(by: {
                $0.intersection(currentFrame).area < $1.intersection(currentFrame).area
            }), anchorScreen.area > 0
        else {
            return target
        }

        var clamped = target
        clamped.origin.x = clampedValue(
            target.origin.x,
            min: anchorScreen.minX - target.width + thresholdWidth,
            max: anchorScreen.maxX - thresholdWidth
        )
        clamped.origin.y = clampedValue(
            target.origin.y,
            min: anchorScreen.minY,
            max: anchorScreen.maxY - thresholdHeight
        )

        return clamped
    }

    /// Keeps `target` fully inside the union of every screen's full frame.
    private func clampToAllScreens(_ target: CGRect) -> CGRect {
        let union = flipToAXSpace(screensUnionFrame)

        guard union.width > 0, union.height > 0 else {
            return target
        }

        var clamped = target
        clamped.size.width = min(target.width, union.width)
        clamped.size.height = min(target.height, union.height)
        clamped.origin.x = clampedValue(
            target.origin.x,
            min: union.minX,
            max: union.maxX - clamped.width
        )
        clamped.origin.y = clampedValue(
            target.origin.y,
            min: union.minY,
            max: union.maxY - clamped.height
        )

        return clamped
    }

    /// Keeps `target` fully inside the visible frame of the screen `currentFrame` sits on.
    private func clampToCurrentScreen(_ target: CGRect, currentFrame: CGRect) -> CGRect {
        let screens = axScreenFrames(visible: true)

        guard
            let screen = screens.max(by: {
                $0.intersection(currentFrame).area < $1.intersection(currentFrame).area
            }), screen.width > 0, screen.height > 0
        else {
            return target
        }

        var clamped = target
        clamped.size.width = min(target.width, screen.width)
        clamped.size.height = min(target.height, screen.height)
        clamped.origin.x = clampedValue(
            target.origin.x,
            min: screen.minX,
            max: screen.maxX - clamped.width
        )
        clamped.origin.y = clampedValue(
            target.origin.y,
            min: screen.minY,
            max: screen.maxY - clamped.height
        )

        return clamped
    }

    private func clampedValue(_ value: CGFloat, min lower: CGFloat, max upper: CGFloat) -> CGFloat
    {
        // A screen narrower/shorter than the margin would otherwise invert the range.
        guard lower <= upper else {
            return value
        }

        return Swift.min(Swift.max(value, lower), upper)
    }

    /// Every screen's frame (or visible frame), converted to AX coordinates.
    private func axScreenFrames(visible: Bool) -> [CGRect] {
        NSScreen.screens.map { flipToAXSpace(visible ? $0.visibleFrame : $0.frame) }
    }

    /// Flips a frame from AppKit's bottom-left-origin coordinates to AX's top-left-origin
    /// coordinates, using the same union reference for every screen so relative positions between
    /// displays are preserved.
    private func flipToAXSpace(_ frame: CGRect) -> CGRect {
        let unionFrame = screensUnionFrame

        var flipped = frame
        flipped.origin.y = unionFrame.maxY - frame.origin.y - frame.height

        return flipped
    }
}
