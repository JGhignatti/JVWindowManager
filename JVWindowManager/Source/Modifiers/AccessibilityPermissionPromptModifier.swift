//
//  AccessibilityPermissionPromptModifier.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import SwiftUI

struct AccessibilityPermissionPromptModifier: ViewModifier {
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

    func body(content: Content) -> some View {
        content
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
}
