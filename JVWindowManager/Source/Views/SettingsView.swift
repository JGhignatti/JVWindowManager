//
//  SettingsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

private enum SettingsNavLink {
    case general, defaultLayouts, customLayouts
}

struct SettingsView: View {
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
    }
}

#Preview {
    SettingsView()
}
