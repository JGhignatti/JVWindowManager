//
//  ActionPreviewView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/04/25.
//

import SwiftUI

struct ActionPreviewView: View {
    var actionRect: ActionRect

    var body: some View {
        let screenSize =
            NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900)
        let scaleFactor = 300 / max(screenSize.width, screenSize.height)
        let scaledSize = CGSize(
            width: screenSize.width * scaleFactor,
            height: screenSize.height * scaleFactor
        )

        let windowRect = CGRect(
            origin: .init(x: screenSize.width / 6, y: screenSize.height / 6),
            size: .init(
                width: screenSize.width / 2,
                height: screenSize.height / 2
            )
        )
        let scaledWindow = CGRect(
            x: windowRect.origin.x * scaleFactor,
            y: windowRect.origin.y * scaleFactor,
            width: windowRect.width * scaleFactor,
            height: windowRect.height * scaleFactor
        )

        let previewRect: CGRect =
            (try? actionRect.evaluate(for: windowRect)) ?? .zero
        let scaledPreview = CGRect(
            x: previewRect.origin.x * scaleFactor,
            y: previewRect.origin.y * scaleFactor,
            width: previewRect.width * scaleFactor,
            height: previewRect.height * scaleFactor
        )

        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: scaledSize.width, height: scaledSize.height)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.red.opacity(0.6))
                .frame(width: scaledWindow.width, height: scaledWindow.height)
                .offset(
                    x: scaledWindow.origin.x,
                    y: scaledWindow.origin.y
                )

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(0.4))
                .frame(width: scaledPreview.width, height: scaledPreview.height)
                .offset(
                    x: scaledPreview.origin.x,
                    y: scaledPreview.origin.y
                )
        }
        .frame(width: scaledSize.width, height: scaledSize.height)
    }
}

#Preview {
    ActionPreviewView(
        actionRect: .init(
            width: "width",
            height: "height",
            x: "originX + step",
            y: "originY + step"
        )
    )
}
