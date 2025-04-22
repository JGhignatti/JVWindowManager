//
//  LayoutShortcutRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 17/04/25.
//

import SwiftUI

struct LayoutShortcutRowView: View {
    let layoutShortcut: LayoutShortcut
    let showDivider: Bool

    //    let layout: Layout
    //    @Binding var shortcut: KeyboardShortcut?
    //    let showDivider: Bool
    //    let onShortcutChange: (KeyboardShortcut?) -> Void
    //
    //    @State private var isCapturing = false

    var body: some View {
        VStack {
            Toggle(isOn: .constant(layoutShortcut.enabled)) {
                HStack {
                    Text(layoutShortcut.name)
                    Spacer()
                    Text(layoutShortcut.keyCombo.modifiers.description)
                    Text(layoutShortcut.keyCombo.key.description)
                }
                .padding(.trailing, 8)
            }
            .toggleStyle(.switch)

            if showDivider {
                Divider()
            }
        }
        //        VStack(spacing: 4) {
        //            HStack {
        //                Text(layout.name)
        //                Spacer()
        //                Text("\(layout.modifiers)")
        //                ShortcutCaptureView(
        //                    shortcut: $shortcut,
        //                    modifiers: layout.modifiers,
        //                    isCapturing: $isCapturing
        //                )
        //                .frame(width: 100)
        //
        //                Button {
        //                    shortcut = nil
        //                    onShortcutChange(nil)
        //                } label: {
        //                    Image(systemName: "xmark.circle.fill")
        //                        .foregroundColor(.secondary)
        //                        .help("Clear shortcut")
        //                }
        //                .buttonStyle(.borderless)
        //            }
        //
        //            if showDivider {
        //                Divider()
        //            }
        //        }
        //        .onChange(of: shortcut) { _, newValue in
        //            onShortcutChange(newValue)
        //        }
    }
}

#Preview {
    LayoutShortcutRowView(
        layoutShortcut: Layout.fullScreen.defaultLayoutShortcut,
        showDivider: true
    )
    LayoutShortcutRowView(
        layoutShortcut: Layout.topHalf.defaultLayoutShortcut,
        showDivider: false
    )
}
