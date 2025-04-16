//
//  JVWindowManagerApp.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

@main
struct JVWindowManagerApp: App {
    @State private var isPermissionGranted: Bool?
    @State private var isFirstSettingsLaunch = true

    private var showPermissionAlert: Bool {
        guard let _isPermissionGranted = isPermissionGranted,
            isPermissionGranted != nil
        else {
            return false
        }

        return !_isPermissionGranted && isFirstSettingsLaunch
    }
    
    init() {
        HotKeysManager.shared.registerAll()
    }
    
    var body: some Scene {
        Window("JV Window Manager", id: K.WindowId.Settings) {
            SettingsMainView()
                .identifyWindow(K.WindowId.Settings)
                .onAppear {
                    isPermissionGranted =
                        AccessibilityPermissionManager.shared
                        .isPermissionGranted
                }
                .onDisappear {
                    isFirstSettingsLaunch = false
                }
                .alert(
                    "Accessibility Permission Required",
                    isPresented: Binding(
                        get: {
                            showPermissionAlert
                        },
                        set: { _ in }
                    )
                ) {
                    Button("OK") {
                        AccessibilityPermissionManager.shared.promptIfNeeded()
                    }

                    Button("Quit", role: .cancel) {
                        NSApp.terminate(nil)
                    }
                } message: {
                    Text(
                        """
                        This app needs permission to control other apps' windows.
                        Please click OK and grant access in System Settings → Privacy & Security → Accessibility.
                        """
                    )
                }
        }

        MenuBarExtra(
            "JV Window Manager",
            systemImage: "inset.filled.lefthalf.topright.bottomright.rectangle"
        ) {
            MenuBarExtraView()
        }
    }
}
