//
//  JVWindowManagerApp.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import Defaults
import SwiftUI

@main
struct JVWindowManagerApp: App {
    init() {
        // Leftover from the pre-Defaults-key-based v1 storage, superseded by `.actions`.
        UserDefaults.standard.removeObject(forKey: "customActions")

        if !Defaults[.hasLoadedDefaultLayouts] {
            Defaults[.layouts] = getDefaultLayouts()
            Defaults[.hasLoadedDefaultLayouts] = true
        }

        if !Defaults[.hasLoadedDefaultActions] {
            Defaults[.actions] = getDefaultActions()
            Defaults[.hasLoadedDefaultActions] = true
        }

        _ = ShortcutsManager.shared

        AccessibilityPermissionManager.shared.requestPermission()
    }

    var body: some Scene {
        Window("JV Window Manager", id: K.WindowId.Settings) {
            SettingsWindowView()
        }
        .defaultSize(width: 760, height: 560)
        .windowResizability(.contentSize)
        .restorationDisabled()

        MenuBarExtra(
            "JV Window Manager",
            systemImage: "inset.filled.lefthalf.topright.bottomright.rectangle"
        ) {
            MenuBarExtraView()
        }
    }
}

extension Scene {
    fileprivate func restorationDisabled() -> some Scene {
        if #available(macOS 15.0, *) {
            return restorationBehavior(.disabled)
        } else {
            return self
        }
    }
}
