//
//  VariableRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 12/08/25.
//

import SwiftUI

struct VariableRowView<Content: View>: View {
    let name: String
    let identifier: String
    let caption: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let defaultValue: Int
    let content: Content

    init(
        name: String,
        identifier: String,
        caption: String,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        defaultValue: Int,
        @ViewBuilder content: () -> Content
    ) {
        self.name = name
        self.identifier = identifier
        self.caption = caption
        self._value = value
        self.range = range
        self.defaultValue = defaultValue
        self.content = content()
    }

    private var isDefault: Bool {
        value == defaultValue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(name)

                    Text(identifier)
                        .inlineCode(.caption2)
                }

                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Slider(
                    value: Binding<Double>(
                        get: {
                            Double(value)
                        },
                        set: { newValue in
                            value = Int(newValue.rounded())
                        }
                    ),
                    in: Double(range.lowerBound)...Double(range.upperBound)
                ) {
                    EmptyView()
                } minimumValueLabel: {
                    Text("\(range.lowerBound)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } maximumValueLabel: {
                    Text("\(range.upperBound)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 220, maxWidth: .infinity)
                .labelsHidden()

                TextField(
                    name,
                    value: $value,
                    format: .number
                )
                .labelsHidden()
                .multilineTextAlignment(.trailing)
                .frame(width: 40)
                .onSubmit {
                    value = min(max(value, range.lowerBound), range.upperBound)
                }

                Stepper(name, value: $value, in: range)
                    .labelsHidden()

                Button {
                    withAnimation(.snappy) {
                        value = defaultValue
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.borderless)
                .help("Reset to \(defaultValue)")
                .accessibilityLabel("Reset \(name) to \(defaultValue)")
                .opacity(isDefault ? 0 : 1)
                .disabled(isDefault)
                .accessibilityHidden(isDefault)

                content
                    .frame(width: 60, height: 60, alignment: .top)
            }
        }
        .contextMenu {
            Button("Reset to Default (\(defaultValue))") {
                withAnimation(.snappy) {
                    value = defaultValue
                }
            }
            .disabled(isDefault)
        }
        .accessibilityLabel(name)
        .padding(.vertical, 4)
    }
}

#Preview {
    Form {
        VariableRowView(
            name: "Variable",
            identifier: "variable",
            caption: "This is a variable",
            value: .constant(10),
            range: 0...50,
            defaultValue: 16,
            content: {
                Text("Hello")
            }
        )
    }
    .formStyle(.grouped)
}
