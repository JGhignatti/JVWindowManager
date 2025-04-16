//
//  AccessibilityPermissionManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import ApplicationServices

final class AccessibilityPermissionManager {
    static let shared = AccessibilityPermissionManager()

    var isPermissionGranted: Bool {
        AXIsProcessTrusted()
    }

    func promptIfNeeded() {
        guard !isPermissionGranted else {
            return
        }

        let options: CFDictionary =
            [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
            as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }
}
