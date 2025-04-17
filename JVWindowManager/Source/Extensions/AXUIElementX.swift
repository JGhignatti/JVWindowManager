//
//  AXUIElementX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import AppKit

extension AXUIElement {
    func getAttributeValue(for attribute: NSAccessibility.Attribute)
        -> CFTypeRef?
    {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            self,
            attribute.rawValue as CFString,
            &value
        )

        guard result == .success else {
            return nil
        }

        return value
    }

    func setAttributeValue(
        _ value: CFTypeRef,
        for attribute: NSAccessibility.Attribute
    ) -> Bool {
        let result = AXUIElementSetAttributeValue(
            self,
            attribute.rawValue as CFString,
            value
        )

        return result == .success
    }
}

func withEnhancedUserInterfaceDisabled(
    for app: NSRunningApplication,
    perform action: () -> Void
) {
    let appElement = AXUIElementCreateApplication(app.processIdentifier)

    var originalValue: CFTypeRef?
    let key = "AXEnhancedUserInterface" as CFString

    _ = AXUIElementCopyAttributeValue(appElement, key, &originalValue)
    let wasEnabled = (originalValue as? Bool) ?? false

    if wasEnabled {
        AXUIElementSetAttributeValue(appElement, key, kCFBooleanFalse)
    }

    action()

    if wasEnabled {
        AXUIElementSetAttributeValue(appElement, key, kCFBooleanTrue)
    }
}
