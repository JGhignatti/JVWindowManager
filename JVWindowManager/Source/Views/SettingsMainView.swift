//
//  SettingsMainView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

private enum SettingsNavLink {
    case general, defaultLayouts, customLayouts
}

struct SettingsMainView: View {
    @State private var splitViewVisibility: NavigationSplitViewVisibility =
        .doubleColumn
    @State private var selectedItem: SettingsNavLink = .general
    @State private var isLayoutsExpanded = true

    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            List(selection: $selectedItem) {
                NavigationLink(value: SettingsNavLink.general) {
                    Label("General", systemImage: "gear")
                }
                DisclosureGroup(
                    isExpanded: $isLayoutsExpanded,
                    content: {
                        NavigationLink(
                            value: SettingsNavLink.defaultLayouts
                        ) {
                            Label("Default", systemImage: "repeat")
                        }
                        NavigationLink(
                            value: SettingsNavLink.customLayouts
                        ) {
                            Label("Custom", systemImage: "pencil")
                        }
                    },
                    label: {
                        Label("Layouts", systemImage: "inset.filled.topleft.rectangle")
                    }
                )
            }
            .frame(minWidth: 180)
            .padding(.top)
        } detail: {
            switch selectedItem {
            case .general:
                GeneralView()
            case .defaultLayouts:
                DefaultLayoutsView()
            case .customLayouts:
                CustomLayoutsView()
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
