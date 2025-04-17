//
//  ShortcutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct ShortcutsView: View {
    @State private var defaultLayoutShortcutPairs: [LayoutShortcutPair] =
        SettingsManager.shared.defaultLayoutShortcutPairs

    var body: some View {
        ScrollView {
            GroupBox(
                label: Text("Default layouts")
                    .padding(.bottom, 4)
                    .foregroundColor(.secondary)
            ) {
                VStack {
                    ForEach(defaultLayoutShortcutPairs.indices, id: \.self) {
                        index in
                        LayoutShortcutRowView(
                            layout: defaultLayoutShortcutPairs[index].layout,
                            shortcut: $defaultLayoutShortcutPairs[index]
                                .shortcut,
                            showDivider: index != defaultLayoutShortcutPairs
                                .count - 1
                        ) { updatedShortcut in
                            defaultLayoutShortcutPairs[index].shortcut =
                                updatedShortcut

                            SettingsManager.shared.defaultLayoutShortcutPairs =
                                defaultLayoutShortcutPairs
                        }
                    }
                }
                .padding(4)
            }
        }
        .contentMargins(.all, 16, for: .scrollContent)
    }
}

#Preview {
    ShortcutsView()
}
