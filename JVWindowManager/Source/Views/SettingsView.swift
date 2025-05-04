//
//  SettingsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

private enum SettingsNavLink {
    case about, general, defaultLayouts, customLayouts, defaultActions, customActions
}

struct SettingsView: View {
    @State private var selectedItem: SettingsNavLink = .about

    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(selection: $selectedItem) {
                    NavigationLink(value: SettingsNavLink.about) {
                        Label("About", systemImage: "info.circle")
                    }
                    
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
                    
                    Text("Actions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    NavigationLink(value: SettingsNavLink.defaultActions) {
                        Label(
                            "Default",
                            systemImage: "viewfinder"
                        )
                    }
                    
                    NavigationLink(value: SettingsNavLink.customActions) {
                        Label(
                            "Custom",
                            systemImage: "plus.viewfinder"
                        )
                    }
                }
                .frame(minWidth: 180)
                .padding(.top)
            },
            detail: {
                switch selectedItem {
                case .about:
                    AboutView()
                case .general:
                    GeneralView()
                case .defaultLayouts:
                    DefaultLayoutsView()
                case .customLayouts:
                    CustomLayoutsView()
                case .defaultActions:
                    DefaultActionsView()
                case .customActions:
                    CustomActionsView()
                }
            }
        )
    }
}

#Preview {
    SettingsView()
}
