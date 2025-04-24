//
//  MenuBarExtraView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct MenuBarExtraView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Section("JV Window Manager") {
            VStack {
                Button("Settings...") {
                    NSApp.setActivationPolicy(.regular)
                    openWindow(id: K.WindowId.Settings)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        bringSettingsWindowToFront()
                    }
                }

                Button("Quit") {
                    NSApp.terminate(nil)
                }
            }
        }
    }

    private func bringSettingsWindowToFront() {
        if let window = NSApp.windows.first(where: {
            $0.identifier?.rawValue == K.WindowId.Settings
        }) {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

#Preview {
    MenuBarExtraView()
}
