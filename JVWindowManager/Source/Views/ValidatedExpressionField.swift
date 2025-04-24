//
//  ValidatedExpressionField.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 22/04/25.
//

import Combine
import Expression
import SwiftUI

struct ValidatedExpressionField: View {
//    let label: String
//    @Binding var text: String
//    @Binding var isValid: Bool
//    let variables: [String: Double]
//
//    @State private var debounceTimer: AnyCancellable?

    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            TextField(label, text: $text)
//                .textFieldStyle(.roundedBorder)
//                .border(isValid ? Color.clear : Color.red)
//                .onChange(of: text) { _, newValue in
//                    debounceTimer?.cancel()
//                    debounceTimer = Just(newValue)
//                        .delay(for: .milliseconds(150), scheduler: RunLoop.main)
//                        .sink { value in
//                            validate(expression: value)
//                        }
//                }
//
//            if !isValid {
//                Text("⚠️ Invalid expression")
//                    .font(.caption)
//                    .foregroundColor(.red)
//            }
//        }
    }

//    private func validate(expression: String) {
//        do {
//            _ = try Expression(expression, constants: variables).evaluate()
//            isValid = true
//        } catch {
//            isValid = false
//        }
//    }
}

#Preview {
    ValidatedExpressionField(
//        label: "Label",
//        text: .constant(""),
//        isValid: .constant(true),
//        variables: [:]
    )
}
