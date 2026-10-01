//
//  ActionPreviewView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/04/25.
//

import SwiftUI

/// Shows a sample window and a fading trail of where it will land after the next few presses of
/// an ``Action``'s shortcut, since a single press is usually a small change meant to be repeated.
struct ActionPreviewView: View {
    var actionRect: ActionRect
    var maxDimension: CGFloat = 300
    /// The field currently being edited, if any. Its edges are tinted to show which part of the
    /// preview the focused expression field controls.
    var focusedField: ActionField? = nil

    private var isThumbnail: Bool {
        maxDimension < 100
    }

    /// How many ghost outlines to draw. Kept small on thumbnails so they stay legible.
    private var ghostCount: Int {
        isThumbnail ? 3 : 5
    }

    /// A sample window, roughly the shape of a real one, used both to lay out this preview and to
    /// evaluate `width`/`height`/`originX`/`originY` when showing a live value next to a field.
    static var sampleWindowFrame: CGRect {
        let screenSize = LayoutPreviewView.referenceScreenSize
        let width = screenSize.width * 0.45
        let height = screenSize.height * 0.5

        return CGRect(
            x: (screenSize.width - width) / 2,
            y: (screenSize.height - height) / 2,
            width: width,
            height: height
        )
    }

    /// Below this scaled-point gap between one press and the next, consecutive ghosts would sit on
    /// top of each other, so the trail skips ahead by a stride instead.
    private static let minimumGhostGap: CGFloat = 6
    private static let strides = [1, 5, 10, 25, 50]

    var body: some View {
        let screenSize = LayoutPreviewView.referenceScreenSize
        let scaleFactor = maxDimension / max(screenSize.width, screenSize.height)
        let cornerRadius = min(8, maxDimension / 25)

        let scaledScreenSize = CGSize(
            width: screenSize.width * scaleFactor,
            height: screenSize.height * scaleFactor
        )

        let scaledRect: (CGRect) -> CGRect = { rect in
            CGRect(
                x: rect.origin.x * scaleFactor,
                y: rect.origin.y * scaleFactor,
                width: rect.width * scaleFactor,
                height: rect.height * scaleFactor
            )
        }

        let base = Self.sampleWindowFrame
        let isExpressionInvalid = !actionRect.valid
        // Precomputed far enough ahead to cover the largest stride below.
        let fullTrail =
            isExpressionInvalid ? [] : trail(from: base, steps: ghostCount * Self.strides.last!)
        let isInvalid = isExpressionInvalid || fullTrail.isEmpty

        let firstPress = fullTrail.first

        let firstPressScaledDelta: CGFloat = {
            guard let firstPress else { return 0 }

            let scaledBase = scaledRect(base)
            let scaledFirst = scaledRect(firstPress)

            return max(
                abs(scaledFirst.minX - scaledBase.minX),
                abs(scaledFirst.maxX - scaledBase.maxX),
                abs(scaledFirst.minY - scaledBase.minY),
                abs(scaledFirst.maxY - scaledBase.maxY)
            )
        }()

        let stride =
            Self.strides.first {
                $0 == Self.strides.last || firstPressScaledDelta * CGFloat($0) >= Self.minimumGhostGap
            } ?? 1

        let ghosts: [Ghost] = (1...ghostCount).compactMap { multiple in
            let press = multiple * stride
            let index = press - 1

            guard index < fullTrail.count else {
                return nil
            }

            return Ghost(press: press, frame: fullTrail[index])
        }

        let isPureMove =
            firstPress.map {
                abs($0.width - base.width) < 0.5 && abs($0.height - base.height) < 0.5
            } ?? false

        let edgeChanges: [EdgeChange] =
            firstPress.map { edgeChanges(from: base, to: $0) } ?? []

        VStack(spacing: 6) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color(nsColor: .quaternaryLabelColor))

                if !isInvalid {
                    ForEach(Array(ghosts.enumerated()), id: \.element.id) { index, ghost in
                        let scaled = scaledRect(ghost.frame)
                        let opacity = ghostOpacity(index: index, count: ghosts.count)
                        let isOutermost = ghost.press == ghosts.last?.press

                        RoundedRectangle(cornerRadius: cornerRadius / 2)
                            .strokeBorder(
                                Color.blue.opacity(opacity),
                                style: StrokeStyle(lineWidth: isThumbnail ? 0.75 : 1, dash: [4, 2])
                            )
                            .frame(width: scaled.width, height: scaled.height)
                            .offset(x: scaled.minX, y: scaled.minY)

                        // Only the farthest ghost is labeled — at this scale, labeling every one
                        // of them would just pile the text on top of itself.
                        if !isThumbnail, isOutermost {
                            Text("\(ghost.press)×")
                                .font(.caption2.monospaced())
                                .foregroundStyle(Color.blue.opacity(min(opacity + 0.2, 1)))
                                .padding(.horizontal, 3)
                                .padding(.vertical, 1)
                                .background(
                                    .background.opacity(0.8), in: RoundedRectangle(cornerRadius: 3)
                                )
                                .offset(x: scaled.maxX - 18, y: scaled.minY - 14)
                        }
                    }
                }

                let scaledBase = scaledRect(base)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isInvalid ? Color.red.opacity(0.15) : Color.blue.opacity(0.6))
                    .strokeBorder(
                        isInvalid ? Color.red.opacity(0.7) : Color(nsColor: .tertiaryLabelColor),
                        style: isThumbnail
                            ? StrokeStyle(lineWidth: 0.5)
                            : StrokeStyle(lineWidth: 1)
                    )
                    .frame(width: scaledBase.width, height: scaledBase.height)
                    .offset(x: scaledBase.minX, y: scaledBase.minY)

                if !isInvalid, let firstPress {
                    let scaledFirst = scaledRect(firstPress)
                    let realDelta = CGPoint(
                        x: firstPress.midX - base.midX,
                        y: firstPress.midY - base.midY
                    )

                    if isPureMove {
                        moveIndicator(scaledFrom: scaledBase, scaledTo: scaledFirst, realDelta: realDelta)
                    } else if !isThumbnail {
                        ForEach(edgeChanges) { change in
                            edgeIndicator(change, scaledBase: scaledBase)
                        }
                    }
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
                    Text("Invalid action")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            if !isInvalid, !isThumbnail, let firstPress {
                VStack(spacing: 2) {
                    if stride > 1 {
                        Text("Showing every \(stride)th press")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Text(perPressCaption(from: base, to: firstPress))
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: max(scaledScreenSize.width, 260))
            }
        }
        .animation(.snappy, value: focusedField)
    }

    /// Repeatedly applies `actionRect` starting from `base`, stopping early if an evaluation fails
    /// or produces a degenerate frame.
    private func trail(from base: CGRect, steps: Int) -> [CGRect] {
        var result: [CGRect] = []
        var current = base

        for _ in 0..<steps {
            guard let next = try? actionRect.evaluate(for: current),
                next.width.isFinite, next.height.isFinite,
                next.origin.x.isFinite, next.origin.y.isFinite,
                next.width > 0, next.height > 0
            else {
                break
            }

            result.append(next)
            current = next
        }

        return result
    }

    private func ghostOpacity(index: Int, count: Int) -> Double {
        guard count > 1 else {
            return 0.6
        }

        let progress = Double(index) / Double(count - 1)

        return 0.8 - progress * 0.6
    }

    private struct Ghost: Identifiable {
        let press: Int
        let frame: CGRect

        var id: Int { press }
    }

    private struct EdgeChange: Identifiable {
        let edge: Edge
        /// Positive when this edge moved outward (the window grew on that side).
        let growth: CGFloat

        var id: Edge { edge }
    }

    /// The four edges' outward growth between `from` and `to`, keeping only edges that actually
    /// moved.
    private func edgeChanges(from: CGRect, to: CGRect) -> [EdgeChange] {
        let changes: [(Edge, CGFloat)] = [
            (.leading, from.minX - to.minX),
            (.trailing, to.maxX - from.maxX),
            (.top, from.minY - to.minY),
            (.bottom, to.maxY - from.maxY),
        ]

        return changes
            .filter { abs($0.1) > 0.5 }
            .map { EdgeChange(edge: $0.0, growth: $0.1) }
    }

    private func isFieldFocused(for edge: Edge) -> Bool {
        switch (focusedField, edge) {
        case (.width, .leading), (.width, .trailing): true
        case (.height, .top), (.height, .bottom): true
        case (.x, .leading): true
        case (.y, .top): true
        default: false
        }
    }

    /// `scaledFrom`/`scaledTo` place the arrow between the (already scaled) base window and its
    /// first-press ghost; `realDelta`, in real points, is what the badge displays.
    @ViewBuilder
    private func moveIndicator(
        scaledFrom: CGRect,
        scaledTo: CGRect,
        realDelta: CGPoint
    ) -> some View {
        if let symbol = arrowSymbol(dx: realDelta.x, dy: realDelta.y) {
            let magnitude = max(abs(realDelta.x), abs(realDelta.y))
            let midX = (scaledFrom.midX + scaledTo.midX) / 2
            let midY = (scaledFrom.midY + scaledTo.midY) / 2
            let isFocused = focusedField == .x || focusedField == .y

            VStack(spacing: 1) {
                Image(systemName: symbol)
                    .font(.system(size: isThumbnail ? 10 : 13, weight: .bold))

                if !isThumbnail {
                    Text("\(Int(magnitude.rounded())) pt")
                        .font(.caption2.monospaced())
                }
            }
            .foregroundStyle(isFocused ? Color.accentColor : Color.primary.opacity(0.85))
            .padding(4)
            .background(.background.opacity(0.85), in: RoundedRectangle(cornerRadius: 5))
            .frame(width: isThumbnail ? 18 : 40, height: isThumbnail ? 18 : 36)
            .offset(x: midX - (isThumbnail ? 9 : 20), y: midY - (isThumbnail ? 9 : 18))
        }
    }

    @ViewBuilder
    private func edgeIndicator(_ change: EdgeChange, scaledBase: CGRect) -> some View {
        let isFocused = isFieldFocused(for: change.edge)
        let symbol = chevronSymbol(for: change.edge, growth: change.growth)
        let label = "\(change.growth > 0 ? "+" : "")\(Int(change.growth.rounded())) pt"

        let position: CGPoint = {
            switch change.edge {
            case .leading: CGPoint(x: scaledBase.minX, y: scaledBase.midY)
            case .trailing: CGPoint(x: scaledBase.maxX, y: scaledBase.midY)
            case .top: CGPoint(x: scaledBase.midX, y: scaledBase.minY)
            case .bottom: CGPoint(x: scaledBase.midX, y: scaledBase.maxY)
            }
        }()

        HStack(spacing: 2) {
            Image(systemName: symbol)
                .font(.system(size: 10, weight: .bold))

            Text(label)
                .font(.caption2.monospaced())
        }
        .foregroundStyle(isFocused ? Color.accentColor : Color.primary.opacity(0.85))
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(.background.opacity(0.85), in: RoundedRectangle(cornerRadius: 5))
        .fixedSize()
        .offset(x: position.x - 24, y: position.y - 9)
    }

    private func arrowSymbol(dx: CGFloat, dy: CGFloat) -> String? {
        let threshold: CGFloat = 0.5
        let horizontal = dx > threshold ? 1 : (dx < -threshold ? -1 : 0)
        let vertical = dy > threshold ? 1 : (dy < -threshold ? -1 : 0)

        switch (horizontal, vertical) {
        case (0, 0): return nil
        case (0, -1): return "arrow.up"
        case (0, 1): return "arrow.down"
        case (-1, 0): return "arrow.left"
        case (1, 0): return "arrow.right"
        case (-1, -1): return "arrow.up.left"
        case (1, -1): return "arrow.up.right"
        case (-1, 1): return "arrow.down.left"
        case (1, 1): return "arrow.down.right"
        default: return nil
        }
    }

    /// A chevron pointing outward (growing) or inward (shrinking) for the given edge.
    private func chevronSymbol(for edge: Edge, growth: CGFloat) -> String {
        switch edge {
        case .leading: growth > 0 ? "chevron.left" : "chevron.right"
        case .trailing: growth > 0 ? "chevron.right" : "chevron.left"
        case .top: growth > 0 ? "chevron.up" : "chevron.down"
        case .bottom: growth > 0 ? "chevron.down" : "chevron.up"
        }
    }

    private func perPressCaption(from base: CGRect, to first: CGRect) -> String {
        func signed(_ value: CGFloat) -> String {
            let rounded = Int(value.rounded())
            return rounded > 0 ? "+\(rounded)" : "\(rounded)"
        }

        let widthDelta = signed(first.width - base.width)
        let heightDelta = signed(first.height - base.height)
        let xDelta = signed(first.origin.x - base.origin.x)
        let yDelta = signed(first.origin.y - base.origin.y)

        return "Per press: W \(widthDelta) · H \(heightDelta) · X \(xDelta) · Y \(yDelta)"
    }
}

#Preview("Move") {
    ActionPreviewView(
        actionRect: .init(
            width: "width",
            height: "height",
            x: "originX + step",
            y: "originY"
        )
    )
    .padding()
}

#Preview("Resize one side") {
    ActionPreviewView(
        actionRect: .init(
            width: "width + step",
            height: "height",
            x: "originX",
            y: "originY"
        ),
        focusedField: .width
    )
    .padding()
}

#Preview("Resize all sides") {
    ActionPreviewView(
        actionRect: .init(
            width: "width + step",
            height: "height + step",
            x: "originX - (step / 2)",
            y: "originY - (step / 2)"
        )
    )
    .padding()
}

#Preview("Thumbnails") {
    HStack(spacing: 16) {
        VStack {
            ActionPreviewView(
                actionRect: .init(
                    width: "width", height: "height", x: "originX + step", y: "originY"
                ),
                maxDimension: 44
            )
            Text("Move").font(.caption2)
        }

        VStack {
            ActionPreviewView(
                actionRect: .init(
                    width: "width + step", height: "height", x: "originX", y: "originY"
                ),
                maxDimension: 44
            )
            Text("Resize").font(.caption2)
        }
    }
    .padding()
}
