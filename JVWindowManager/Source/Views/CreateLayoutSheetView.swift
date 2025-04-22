//
//  CreateLayoutSheetView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/04/25.
//

import SwiftUI

struct CreateLayoutSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var insetRectExpression = InsetRectExpression(
        top: "gap * 4",
        bottom: "height / 4",
        left: "stageManager",
        right: "width / 2"
    )
    @State private var topValid = true
    @State private var bottomValid = true
    @State private var leftValid = true
    @State private var rightValid = true

    @FocusState private var focusNameField: Bool

    var body: some View {
        VStack {
            HStack {
                TextField("Enter the layout's name...", text: $name)
                    .textFieldStyle(.plain)
                    .focused($focusNameField)
                    .bold()
                    .font(.title)

                Spacer()

                Button("Save") {
                    var list = SettingsManager.shared.customLayoutShortcuts
                    list.append(
                        .init(
                            name: name,
                            keyCombo: .init(
                                key: .return,
                                modifiers: [.control, .option]
                            ),
                            insetRectExpression: insetRectExpression
                        )
                    )
                    
                    SettingsManager.shared.customLayoutShortcuts = list
                    
                    dismiss()
                }
                .disabled(!allValid)
                .buttonStyle(.borderedProminent)

                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }

            LayoutPreviewView(insetRectExpression: insetRectExpression)

            Form {
                Section(header: Text("Inset configuration").font(.headline)) {
                    let screenSize =
                        NSScreen.main?.frame.size
                        ?? CGSize(width: 1440, height: 900)
                    let screenRect = CGRect(origin: .zero, size: screenSize)
                    let variables = InsetRectExpression.variables(
                        for: screenRect
                    )

                    ValidatedExpressionField(
                        label: "Top",
                        text: $insetRectExpression.top,
                        isValid: $topValid,
                        variables: variables
                    )
                    ValidatedExpressionField(
                        label: "Bottom",
                        text: $insetRectExpression.bottom,
                        isValid: $bottomValid,
                        variables: variables
                    )
                    ValidatedExpressionField(
                        label: "Left",
                        text: $insetRectExpression.left,
                        isValid: $leftValid,
                        variables: variables
                    )
                    ValidatedExpressionField(
                        label: "Right",
                        text: $insetRectExpression.right,
                        isValid: $rightValid,
                        variables: variables
                    )
                }
            }
            .textFieldStyle(.roundedBorder)

            Spacer(minLength: 16)

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Variables")

                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text("width").inlineCode(.footnote)
                        Text("and")
                        Text("height").inlineCode(.footnote)
                        Text("The screen size")
                    }
                    .padding(.leading)

                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text("gap").inlineCode(.footnote)
                        Text("and")
                        Text("halfGap").inlineCode(.footnote)
                        Text("Following the configured gap size")
                    }
                    .padding(.leading)

                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text("stageManager").inlineCode(.footnote)
                        Text("The configured stage manager size")
                    }
                    .padding(.leading)

                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text("peek").inlineCode(.footnote)
                        Text("The configured peek size")
                    }
                    .padding(.leading)
                }

                Spacer()
            }
            .padding(8)
            .background(Color.blue.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .font(.footnote)
        }
        .onAppear {
            focusNameField = true
        }
        .padding(20)
    }

    private var allValid: Bool {
        !name.isEmpty && topValid && bottomValid && leftValid && rightValid
    }
}

#Preview() {
    CreateLayoutSheetView()
}
