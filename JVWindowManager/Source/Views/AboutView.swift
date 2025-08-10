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
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("JV Window Manager")
                .font(.largeTitle)
            
            Spacer(minLength: 16)

            Text(
                "Find more documentation and report issues in the project's Github repository:"
            )

            Link(
                "https://github.com/JGhignatti/JVWindowManager",
                destination: URL(
                    string: "https://github.com/JGhignatti/JVWindowManager"
                )!
            )
            
            Spacer(minLength: 32)

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
