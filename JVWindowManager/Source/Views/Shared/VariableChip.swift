//
//  VariableChip.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/09/26.
//

import SwiftUI

/// A tappable badge showing a variable's name and its current value, used to insert the variable
/// into a form's last-focused expression field.
struct VariableChip: View {
    let name: String
    let value: Int
    let help: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(name)
                    .font(.system(.caption, design: .monospaced))

                Text("\(value)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.quaternary, in: Capsule())
        }
        .buttonStyle(.plain)
        .help(help)
    }
}

#Preview {
    VariableChip(name: "step", value: 8, help: "A configurable size to use as you wish.") {}
        .padding()
}
