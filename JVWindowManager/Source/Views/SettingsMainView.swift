//
//  SettingsMainView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import KeyboardShortcuts
import SwiftUI

private enum SettingsNavLink {
    case general, defaultLayouts, customLayouts
}

struct SettingsMainView: View {
    @State private var selectedItem: SettingsNavLink = .general

    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(selection: $selectedItem) {
                    NavigationLink(value: SettingsNavLink.general) {
                        Label("General", systemImage: "gear")
                    }

                    Text("Layouts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    NavigationLink(value: SettingsNavLink.defaultLayouts) {
                        Label(
                            "Default",
                            systemImage: "inset.filled.topleft.rectangle"
                        )
                    }

                    NavigationLink(value: SettingsNavLink.customLayouts) {
                        Label(
                            "Custom",
                            systemImage:
                                "inset.filled.center.rectangle.badge.plus"
                        )
                    }
                }
                .frame(minWidth: 180)
                .padding(.top)
            },
            detail: {
                switch selectedItem {
                case .general:
                    GeneralView()
                case .defaultLayouts:
                    DefaultLayoutsView()
                case .customLayouts:
                    CustomLayoutsView()
                }
            }
        )
        .onAppear {
            guard let window = NSApp.keyWindow else { return }

            disableGreenButton(for: window)
            bringToFront(for: window)
        }
    }

    private func bringToFront(for window: NSWindow) {
        DispatchQueue.main.async {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func disableGreenButton(for window: NSWindow) {
        window.standardWindowButton(.zoomButton)?.isEnabled = false
        window.collectionBehavior.remove(.fullScreenPrimary)
        window.collectionBehavior.remove(.fullScreenAllowsTiling)
    }
}

#Preview {
    SettingsMainView()
}
