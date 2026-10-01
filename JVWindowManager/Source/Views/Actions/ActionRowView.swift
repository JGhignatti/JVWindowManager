//
//  ActionRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/05/26.
//

import KeyboardShortcuts
import SwiftUI

struct ActionRowView: View {
    let action: Action

    private let thumbnailDimension: CGFloat = 44

    var body: some View {
        HStack {
            ActionPreviewView(actionRect: action.rect, maxDimension: thumbnailDimension)

            Text(action.name)

            if action.repeatBehavior.isEnabled {
                Image(systemName: "repeat")
                    .foregroundStyle(.secondary)
                    .help("Repeats while held")
            }

            Spacer()

            KeyboardShortcuts.Recorder(for: action.keyboardShortcutsName)
                .shortcutValidation {
                    ShortcutsManager.shared.validateShortcut(
                        $0,
                        excluding: action.id
                    )
                }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    ActionRowView(
        action: .init(
            name: "Move right",
            rect: .init(
                width: "width",
                height: "height",
                x: "originX + step",
                y: "originY"
            )
        )
    )
}
