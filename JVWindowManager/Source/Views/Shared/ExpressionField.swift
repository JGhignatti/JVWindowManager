//
//  ExpressionField.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/09/26.
//

import SwiftUI

/// A labeled text field for one side of an ``EvaluatableRect`` expression, showing its live
/// evaluated value (and, optionally, its per-repeat delta) alongside any evaluation error.
/// `Field` identifies which side this is, for the enclosing form's `FocusState`.
struct ExpressionField<Field: Hashable>: View {
    let title: String
    @Binding var text: String
    let evaluatedValue: Double?
    let errorMessage: String?
    /// The change this expression contributes per press/repeat, shown as an extra "+8 pt" style
    /// badge. `nil` hides the badge.
    var delta: Double?
    var focus: FocusState<Field?>.Binding
    let field: Field

    init(
        _ title: String,
        text: Binding<String>,
        evaluatedValue: Double?,
        errorMessage: String?,
        delta: Double? = nil,
        focus: FocusState<Field?>.Binding,
        field: Field
    ) {
        self.title = title
        self._text = text
        self.evaluatedValue = evaluatedValue
        self.errorMessage = errorMessage
        self.delta = delta
        self.focus = focus
        self.field = field
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack {
                TextField(title, text: $text, prompt: Text("\(title) value"))
                    .font(.body.monospaced())
                    .focused(focus, equals: field)

                if let delta, delta.rounded() != 0 {
                    Text(deltaLabel(delta))
                        .font(.caption.monospaced())
                        .foregroundStyle(Color.accentColor)
                        .fixedSize()
                }

                if let evaluatedValue {
                    Text("\(Int(evaluatedValue.rounded())) pt")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .fixedSize()
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }

    private func deltaLabel(_ delta: Double) -> String {
        let rounded = Int(delta.rounded())

        return rounded > 0 ? "+\(rounded) pt" : "\(rounded) pt"
    }
}

private enum PreviewField: Hashable {
    case a
}

#Preview {
    @Previewable @FocusState var focus: PreviewField?
    @Previewable @State var text = "originX + step"

    Form {
        ExpressionField(
            "X",
            text: $text,
            evaluatedValue: 24,
            errorMessage: nil,
            delta: 8,
            focus: $focus,
            field: .a
        )
    }
    .formStyle(.grouped)
    .frame(width: 420)
}
