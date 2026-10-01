//
//  AboutView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 04/05/25.
//

import SwiftUI

struct AboutView: View {
    private var versionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)

            Text("JV Window Manager")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 12)

            Text(
                "Highly customizable shortcut-based window manager for macOS"
            )
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal)

            VStack(spacing: 6) {
                Text(versionString)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                Link(
                    "GitHub Repository",
                    destination: URL(
                        string: "https://github.com/JGhignatti/JVWindowManager"
                    )!
                )

                HStack(spacing: 4) {
                    Text("Developed by")
                        .foregroundStyle(.secondary)

                    Link(
                        "João Ghignatti",
                        destination: URL(
                            string: "https://github.com/JGhignatti"
                        )!
                    )
                }
            }
            .font(.callout)
            .padding(.top, 24)

            Spacer()

            Text("Copyright © 2026 João Ghignatti. All rights reserved.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .windowToolbar)
    }
}

#Preview {
    AboutView()
}
