//
//  SettingsMainView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

private enum SettingsNavLink {
    case general, shortcuts
}

struct SettingsMainView: View {
    @State private var splitViewVisibility: NavigationSplitViewVisibility =
        .doubleColumn
    @State private var selectedItem: SettingsNavLink = .general

    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            List(selection: $selectedItem) {
                NavigationLink(value: SettingsNavLink.general) {
                    Label("General", systemImage: "gear")
                }
                NavigationLink(value: SettingsNavLink.shortcuts) {
                    Label("Shortcuts", systemImage: "keyboard")
                }
            }
            .frame(minWidth: 180)
            .padding(.top)
        } detail: {
            switch selectedItem {
            case .general:
                GeneralView()
            case .shortcuts:
                ShortcutsView()
            }
        }
        .onAppear {
            guard
                let window = NSApp.windows.first(where: {
                    $0.identifier?.rawValue == K.WindowId.Settings
                })
            else { return }

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
