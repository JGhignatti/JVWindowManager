//
//  MenuBarExtraView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/10/25.
//

import SwiftUI

struct MenuBarExtraView: View {
    @Environment(\.openWindow) private var openWindow

    private var accessibilityManager = AccessibilityPermissionManager.shared

    var body: some View {
        if !accessibilityManager.isPermissionGranted {
            Button("Grant Accessibility Access…") {
                accessibilityManager.requestPermission()
                accessibilityManager.openSystemSettings()
            }

            Divider()
        }

        Button("Settings…") {
            NSApp.setActivationPolicy(.regular)
            openWindow(id: K.WindowId.Settings)
            NSApp.activate()
        }
        .keyboardShortcut(",")

        Divider()

        Button("Quit JV Window Manager") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

#Preview {
    MenuBarExtraView()
}
