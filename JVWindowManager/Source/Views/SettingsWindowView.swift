//
//  SettingsWindowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/10/25.
//

import SwiftUI

private enum SettingsWindowNavLink: CaseIterable, Identifiable {
    case about, general, layouts, actions

    var id: Self { self }

    var title: String {
        switch self {
        case .about: "About"
        case .general: "General"
        case .layouts: "Layouts"
        case .actions: "Actions"
        }
    }

    var systemImage: String {
        switch self {
        case .about: "info.circle"
        case .general: "gear"
        case .layouts: "inset.filled.topleft.rectangle"
        case .actions: "plus.viewfinder"
        }
    }
}

private struct WindowTitleVisibilityAccessor: NSViewRepresentable {
    let isHidden: Bool

    func makeNSView(context: Context) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            nsView.window?.titleVisibility = isHidden ? .hidden : .visible
        }
    }
}

struct SettingsWindowView: View {
    @State private var selectedItem: SettingsWindowNavLink? = .about

    var body: some View {
        NavigationSplitView {
            List(SettingsWindowNavLink.allCases, selection: $selectedItem) {
                item in
                Label(item.title, systemImage: item.systemImage)
            }
            .navigationSplitViewColumnWidth(200)
            .toolbar(removing: .sidebarToggle)
        } detail: {
            switch selectedItem {
            case .about:
                AboutView()
            case .general:
                GeneralView()
            case .layouts:
                LayoutsView()
            case .actions:
                ActionsView()
            case nil:
                EmptyView()
            }
        }
        .frame(minWidth: 680, minHeight: 480)
        .background(WindowTitleVisibilityAccessor(isHidden: selectedItem == .about))
        .onAppear {
            // Shows the Dock icon while the settings window is open.
            NSApp.setActivationPolicy(.regular)
            NSApp.activate()
        }
        .onDisappear {
            // Back to menu bar only once the settings window is closed.
            NSApp.setActivationPolicy(.accessory)
        }
    }
}

#Preview {
    SettingsWindowView()
}
