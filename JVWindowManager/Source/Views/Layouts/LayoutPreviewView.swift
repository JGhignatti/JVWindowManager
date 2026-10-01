//
//  LayoutPreviewView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/04/25.
//

import SwiftUI

struct LayoutPreviewView: View {
    let insetRect: InsetRect
    var maxDimension: CGFloat = 300
    /// The side currently being edited, if any. Its margin is tinted to show which part of the
    /// preview the focused expression field controls.
    var focusedEdge: Edge? = nil

    private var isThumbnail: Bool {
        maxDimension < 100
    }

    /// A representative screen size, used both to lay out this preview and, elsewhere, to evaluate
    /// `width`/`height` when showing a live value next to an expression field.
    static var referenceScreenSize: CGSize {
        NSScreen.main?.visibleFrame.size ?? CGSize(width: 1440, height: 900)
    }

    /// Sides whose expression references `stageManager`. At thumbnail sizes, these get a distinctly colored
    /// margin instead of the plain background, so a Stage Manager reserve doesn't read as an ordinary padding
    /// margin (which, at a few points, would otherwise scale down to the same near-invisible sliver).
    private var stageManagerSides: Set<Edge> {
        var sides = Set<Edge>()

        if insetRect.left.contains("stageManager") { sides.insert(.leading) }
        if insetRect.right.contains("stageManager") { sides.insert(.trailing) }
        if insetRect.top.contains("stageManager") { sides.insert(.top) }
        if insetRect.bottom.contains("stageManager") { sides.insert(.bottom) }

        return sides
    }

    var body: some View {
        let screenSize = Self.referenceScreenSize
        let scaleFactor = maxDimension / max(screenSize.width, screenSize.height)
        let cornerRadius = min(8, maxDimension / 25)

        let scaledScreenSize = CGSize(
            width: screenSize.width * scaleFactor,
            height: screenSize.height * scaleFactor
        )

        let screenRect = CGRect(origin: .zero, size: screenSize)
        let evaluatedRect =
            insetRect.valid ? try? insetRect.evaluate(for: screenRect) : nil
        let previewRect = evaluatedRect ?? screenRect
        // An expression can be syntactically valid yet still produce a degenerate box (e.g. `top` +
        // `bottom` exceeding the screen's height), which is just as unusable as a parse failure.
        let isInvalid =
            evaluatedRect == nil || previewRect.width <= 0
            || previewRect.height <= 0
        let visualRect = visuallyLegibleRect(previewRect, in: screenSize)
        let scaledPreviewRect = CGRect(
            x: visualRect.origin.x * scaleFactor,
            y: visualRect.origin.y * scaleFactor,
            width: visualRect.width * scaleFactor,
            height: visualRect.height * scaleFactor
        )
        // The blue box's origin in top-leading coordinates (the ZStack's coordinate space), matching the
        // `.offset` applied to it below.
        let boxTopOffset =
            scaledScreenSize.height - scaledPreviewRect.origin.y - scaledPreviewRect.height
        let boxLeadingOffset = scaledPreviewRect.origin.x

        // Not gated to thumbnails: at full size this still helps distinguish a Stage Manager
        // reserve from an ordinary padding margin, the same way it does when scaled down.
        let accentMarginRects: [CGRect] =
            isInvalid
            ? []
            : stageManagerSides.map {
                marginRect(
                    for: $0,
                    boxLeadingOffset: boxLeadingOffset,
                    boxTopOffset: boxTopOffset,
                    scaledPreviewRect: scaledPreviewRect,
                    scaledScreenSize: scaledScreenSize
                )
            }

        let focusedMarginRect: CGRect? = {
            guard !isInvalid, let focusedEdge else { return nil }

            return marginRect(
                for: focusedEdge,
                boxLeadingOffset: boxLeadingOffset,
                boxTopOffset: boxTopOffset,
                scaledPreviewRect: scaledPreviewRect,
                scaledScreenSize: scaledScreenSize
            )
        }()

        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(nsColor: .quaternaryLabelColor))

            ForEach(Array(accentMarginRects.enumerated()), id: \.offset) { _, marginRect in
                Rectangle()
                    .fill(Color.orange.opacity(0.55))
                    .frame(width: marginRect.width, height: marginRect.height)
                    .offset(x: marginRect.minX, y: marginRect.minY)
            }

            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isInvalid ? Color.red.opacity(0.15) : Color.blue.opacity(0.6))
                .strokeBorder(
                    isInvalid ? Color.red.opacity(0.7) : Color(nsColor: .tertiaryLabelColor),
                    style: isThumbnail
                        ? StrokeStyle(lineWidth: 0.5)
                        : StrokeStyle(lineWidth: 1, dash: [3, 2])
                )
                .frame(
                    width: scaledPreviewRect.width,
                    height: scaledPreviewRect.height
                )
                .offset(x: boxLeadingOffset, y: boxTopOffset)

            if let focusedMarginRect {
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: focusedMarginRect.width, height: focusedMarginRect.height)
                    .offset(x: focusedMarginRect.minX, y: focusedMarginRect.minY)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: scaledScreenSize.width, height: scaledScreenSize.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay {
            if isThumbnail {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color(nsColor: .separatorColor))
            }
        }
        .overlay {
            if isInvalid, !isThumbnail {
                Text("Invalid layout")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .animation(.snappy, value: focusedEdge)
    }

    /// The rect (in the ZStack's top-leading coordinate space) of the margin strip on the given side, between
    /// the tile's edge and the blue box.
    private func marginRect(
        for side: Edge,
        boxLeadingOffset: CGFloat,
        boxTopOffset: CGFloat,
        scaledPreviewRect: CGRect,
        scaledScreenSize: CGSize
    ) -> CGRect {
        switch side {
        case .leading:
            return CGRect(x: 0, y: 0, width: boxLeadingOffset, height: scaledScreenSize.height)
        case .trailing:
            let x = boxLeadingOffset + scaledPreviewRect.width
            return CGRect(x: x, y: 0, width: scaledScreenSize.width - x, height: scaledScreenSize.height)
        case .top:
            return CGRect(x: 0, y: 0, width: scaledScreenSize.width, height: boxTopOffset)
        case .bottom:
            let y = boxTopOffset + scaledPreviewRect.height
            return CGRect(x: 0, y: y, width: scaledScreenSize.width, height: scaledScreenSize.height - y)
        }
    }

    /// At small thumbnail sizes, a real inset like `padding` (a few points on a 1440pt-wide screen) scales
    /// down to a fraction of a pixel and disappears, making visually distinct layouts (e.g. "Full screen" and
    /// "Stage manager full screen") render as the same solid square. To keep them legible, small margins are
    /// boosted toward a minimum visible size, while margins that are already large (like a half-screen split)
    /// are left untouched. The full-size editor preview (`maxDimension` at its default) is unaffected.
    private func visuallyLegibleRect(_ rect: CGRect, in screenSize: CGSize) -> CGRect {
        guard isThumbnail else {
            return rect
        }

        func legibleFraction(_ fraction: CGFloat) -> CGFloat {
            let threshold: CGFloat = 0.5

            guard fraction > 0, fraction < threshold else {
                return fraction
            }

            return sqrt(fraction * threshold)
        }

        let leftMargin =
            legibleFraction(rect.minX / screenSize.width) * screenSize.width
        let rightMargin =
            legibleFraction((screenSize.width - rect.maxX) / screenSize.width)
            * screenSize.width
        let bottomMargin =
            legibleFraction(rect.minY / screenSize.height) * screenSize.height
        let topMargin =
            legibleFraction((screenSize.height - rect.maxY) / screenSize.height)
            * screenSize.height

        return CGRect(
            x: leftMargin,
            y: bottomMargin,
            width: max(0, screenSize.width - leftMargin - rightMargin),
            height: max(0, screenSize.height - bottomMargin - topMargin)
        )
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

#Preview("Thumbnails: Full screen vs Stage manager") {
    HStack(spacing: 16) {
        ForEach([44, 88, 150], id: \.self) { dimension in
            VStack {
                HStack(spacing: 8) {
                    VStack {
                        LayoutPreviewView(
                            insetRect: .init("padding"),
                            maxDimension: CGFloat(dimension)
                        )
                        Text("Full screen").font(.caption2)
                    }

                    VStack {
                        LayoutPreviewView(
                            insetRect: .init(
                                top: "padding",
                                bottom: "padding",
                                left: "stageManager",
                                right: "padding"
                            ),
                            maxDimension: CGFloat(dimension)
                        )
                        Text("Stage manager").font(.caption2)
                    }
                }
                Text("\(dimension)pt").font(.caption).foregroundStyle(.secondary)
            }
        }
    }
    .padding()
}
