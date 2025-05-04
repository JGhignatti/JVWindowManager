//
//  AboutView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 04/05/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text(
                    "Developed by João Ghignatti"
                )

                Spacer()

                Link(
                    "https://github.com/JGhignatti",
                    destination: URL(
                        string: "https://github.com/JGhignatti"
                    )!
                )
            }

            HStack {
                Spacer()

                Text("Copyright © 2025 João Ghignatti. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .contentMargins(20, for: .scrollContent)
    }
}

#Preview {
    AboutView()
}
