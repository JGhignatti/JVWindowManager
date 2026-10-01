//
//  VariableExampleBoxView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 03/05/26.
//

import SwiftUI

struct VariableExampleBoxView: View {
    let kind: Kind
    let value: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            switch kind {
            case .padding:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.6))
                    .strokeBorder(
                        Color(nsColor: .tertiaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 70, height: 70)
                    .offset(x: CGFloat(value + 5), y: CGFloat(value + 5))
            case .gap:
                let halfValue = Double(value) / 2

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.6))
                    .strokeBorder(
                        Color(nsColor: .tertiaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 40, height: 50)
                    .offset(x: -20 - halfValue)

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.6))
                    .strokeBorder(
                        Color(nsColor: .tertiaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 35, height: 50)
                    .offset(x: 20 + halfValue)
            case .stageManager:
                let delta = mapValue(
                    Double(value),
                    from: 0.0...250.0,
                    to: 0.0...15.0
                )
                let halfDelta = delta / 2

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.6))
                    .strokeBorder(
                        Color(nsColor: .tertiaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 54 - delta, height: 54)
                    .offset(x: halfDelta)
            case .step:
                let delta = mapValue(
                    Double(value),
                    from: 0.0...200.0,
                    to: 0.0...50.0
                )

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(nsColor: .quaternaryLabelColor))
                    .strokeBorder(
                        Color(nsColor: .quaternaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 30, height: 20)
                    .offset(x: -10, y: -10)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.6))
                    .strokeBorder(
                        Color(nsColor: .tertiaryLabelColor),
                        style: StrokeStyle(lineWidth: 1, dash: [3, 2])
                    )
                    .frame(width: 30, height: 20)
                    .offset(
                        x: CGFloat(-10 + delta),
                        y: CGFloat(-10 + delta)
                    )
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(nsColor: .quaternaryLabelColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(Color(nsColor: .separatorColor))
        )
        .animation(.snappy, value: value)
        .help(
            kind == .stageManager || kind == .step
                ? "Not to scale" : ""
        )
    }

    private func mapValue(
        _ value: Double,
        from: ClosedRange<Double>,
        to: ClosedRange<Double>
    ) -> Double {
        let normalized =
            (value - from.lowerBound) / (from.upperBound - from.lowerBound)

        return to.lowerBound + normalized * (to.upperBound - to.lowerBound)
    }

    enum Kind: String {
        case padding, gap, stageManager, step
    }
}

#Preview {
    VariableExampleBoxView(kind: .padding, value: 16)

    VariableExampleBoxView(kind: .gap, value: 16)

    VariableExampleBoxView(kind: .stageManager, value: 160)

    VariableExampleBoxView(kind: .step, value: 32)
}
