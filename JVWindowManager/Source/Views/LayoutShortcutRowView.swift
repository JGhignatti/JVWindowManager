//
//  LayoutShortcutRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 17/04/25.
//

import SwiftUI

struct LayoutShortcutRowView: View {
    let layout: Layout
    @Binding var shortcut: KeyboardShortcut?
    let showDivider: Bool
    let onShortcutChange: (KeyboardShortcut?) -> Void

    @State private var isCapturing = false

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(layout.name)
                Spacer()
                Text("\(layout.modifiers)")
                ShortcutCaptureView(
                    shortcut: $shortcut,
                    modifiers: layout.modifiers,
                    isCapturing: $isCapturing
                )
                .frame(width: 100)

                Button {
                    shortcut = nil
                    onShortcutChange(nil)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .help("Clear shortcut")
                }
                .buttonStyle(.borderless)
            }

            if showDivider {
                Divider()
            }
        }
        .onChange(of: shortcut) { _, newValue in
            onShortcutChange(newValue)
        }
    }
}
