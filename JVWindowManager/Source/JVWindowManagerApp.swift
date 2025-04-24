//
//  JVWindowManagerApp.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import KeyboardShortcuts
import SwiftUI

@main
struct JVWindowManagerApp: App {
    @State private var shortcutState = ShortcutState()
    
    var body: some Scene {
        Window("JV Window Manager", id: K.WindowId.Settings) {
            SettingsMainView()
                .accessibilityPermissionPrompt()
        }
        .defaultSize(width: 800, height: 460)

        MenuBarExtra(
            "JV Window Manager",
            systemImage: "inset.filled.lefthalf.topright.bottomright.rectangle"
        ) {
            MenuBarExtraView()
        }
    }
}

@MainActor
@Observable
final class ShortcutState {
    init() {
        DefaultLayout.allCases.forEach { layout in
            KeyboardShortcuts.onKeyDown(for: layout.keyboardShortcutName) {
                LayoutManager.shared.trigger(layout.insetRect)
            }
        }
    }
}
