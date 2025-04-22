//
//  DefaultLayoutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct DefaultLayoutsView: View {
    @State private var layoutShortcuts = SettingsManager.shared.layoutShortcuts

    var body: some View {
        ScrollView {
            GroupBox {
                VStack {
                    ForEach(layoutShortcuts) { layoutShortcut in
                        LayoutShortcutRowView(
                            layoutShortcut: layoutShortcut,
                            showDivider: layoutShortcuts.firstIndex {
                                $0.id == layoutShortcut.id
                            } != layoutShortcuts.count - 1
                        )
                    }
                }
                .padding(4)
            }
        }
        .contentMargins(.all, 16, for: .scrollContent)
    }
}

#Preview {
    DefaultLayoutsView()
}
