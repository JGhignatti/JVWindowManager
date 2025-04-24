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
                    openWindow(id: K.WindowId.Settings)
                }
                
                Button("Quit") {
                    NSApp.terminate(nil)
                }
            }
        }
    }
}

#Preview {
    MenuBarExtraView()
}
