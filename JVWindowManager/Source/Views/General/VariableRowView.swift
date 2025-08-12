//
//  VariableRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 12/08/25.
//

import SwiftUI

struct VariableRowView: View {
    let name: String
    let caption: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    @State private var showPopover = false

    var body: some View {
        HStack {
            Text(name)
                .frame(width: 100, alignment: .leading)

            Slider(
                value: Binding<Double>(
                    get: {
                        Double(value)
                    },
                    set: { newValue in
                        value = Int(newValue)
                    }
                ),
                in: ClosedRange<Double>(
                    uncheckedBounds: (
                        lower: Double(range.lowerBound),
                        upper: Double(range.upperBound)
                    )
                )
            )
            .controlSize(.mini)

            Text("\(value)")
                .frame(width: 24, alignment: .trailing)

            Button {
                withAnimation {
                    showPopover = true
                }
            } label: {
                Image(systemName: "questionmark.circle")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showPopover, arrowEdge: .bottom) {
                Text(caption)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding(.vertical, 4)
    }
}
