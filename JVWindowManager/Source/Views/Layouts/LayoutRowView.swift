//
//  LayoutRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 13/08/25.
//

import KeyboardShortcuts
import SwiftUI

struct LayoutRowView: View {
    let layout: Layout

    private let thumbnailDimension: CGFloat = 44

    var body: some View {
        HStack {
            LayoutPreviewView(insetRect: layout.rect, maxDimension: thumbnailDimension)

            Text(layout.name)

            Spacer()

            KeyboardShortcuts.Recorder(for: layout.keyboardShortcutsName)
                .shortcutValidation {
                    ShortcutsManager.shared.validateShortcut(
                        $0,
                        excluding: layout.id
                    )
                }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    LayoutRowView(
        layout: .init(name: "Layout", rect: .init("16"))
    )
}
