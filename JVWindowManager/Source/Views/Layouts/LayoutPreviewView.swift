//
//  LayoutPreviewView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/04/25.
//

import SwiftUI

struct LayoutPreviewView: View {
    var insetRect: InsetRect

    var body: some View {
        let screenSize =
            NSScreen.main?.frame.size ?? CGSize(width: 1440, height: 900)
        let scaleFactor = 300 / max(screenSize.width, screenSize.height)
        let scaledSize = CGSize(
            width: screenSize.width * scaleFactor,
            height: screenSize.height * scaleFactor
        )

        let screenRect = CGRect(origin: .zero, size: screenSize)
        let previewRect: CGRect =
            (try? insetRect.evaluate(for: screenRect)) ?? screenRect
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
                .fill(Color.blue.opacity(0.6))
                .frame(width: scaledPreview.width, height: scaledPreview.height)
                .offset(
                    x: scaledPreview.origin.x,
                    y: scaledSize.height - scaledPreview.origin.y
                        - scaledPreview.height
                )
        }
        .frame(width: scaledSize.width, height: scaledSize.height)
    }
}

#Preview {
    LayoutPreviewView(
        insetRect: .init(
            top: "height / 8",
            bottom: "height / 4",
            left: "width / 8",
            right: "width / 4"
        )
    )
}
