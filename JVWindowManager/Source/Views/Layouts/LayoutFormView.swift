//
//  LayoutFormView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/08/25.
//

import Defaults
import Expression
import KeyboardShortcuts
import SwiftUI

/// The side of an ``InsetRect`` an expression field edits, used to track which field is focused so
/// the preview can highlight the matching margin and variable chips know where to insert.
private enum InsetSide: Hashable {
    case top, bottom, left, right
}

struct LayoutFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var rect: InsetRect
    @State private var shortcut: KeyboardShortcuts.Shortcut?

    @State private var showVariablesBox = false

    @State private var showDeleteConfirmation = false

    @FocusState private var focusedField: InsetSide?
    /// The last field that had focus, defaulting to Top. Variable chips insert into this field, so
    /// they keep working even right after a click moves focus away from the text field.
    @State private var lastFocusedField: InsetSide = .top

    private let existing: Layout?
    private let onSave: (Layout) -> Void
    private let onDelete: (() -> Void)?

    /// Starting points offered to new layouts, mirroring `getDefaultLayouts()`'s rects without its
    /// side effect of registering keyboard shortcuts.
    private static let presets: [(name: String, rect: InsetRect)] = [
        ("Full screen", .init("padding")),
        (
            "Top half",
            .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "padding",
                right: "padding"
            )
        ),
        (
            "Bottom half",
            .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "padding",
                right: "padding"
            )
        ),
        (
            "Left half",
            .init(
                top: "padding",
                bottom: "padding",
                left: "padding",
                right: "width / 2 + halfGap"
            )
        ),
        (
            "Right half",
            .init(
                top: "padding",
                bottom: "padding",
                left: "width / 2 + halfGap",
                right: "padding"
            )
        ),
        (
            "Stage Manager full screen",
            .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager",
                right: "padding"
            )
        ),
    ]

    private var focusedEdge: Edge? {
        switch focusedField {
        case .top: .top
        case .bottom: .bottom
        case .left: .leading
        case .right: .trailing
        case nil: nil
        }
    }

    private var previewFrame: CGRect {
        CGRect(origin: .zero, size: LayoutPreviewView.referenceScreenSize)
    }

    private var variableChips: [(name: String, value: Int, help: String)] {
        let variables = Defaults[.variables]
        let referenceSize = LayoutPreviewView.referenceScreenSize

        return [
            ("width", Int(referenceSize.width), "The screen's width."),
            ("height", Int(referenceSize.height), "The screen's height."),
            (
                "padding", variables.padding,
                "Space to frame the window in the screen. Change in General."
            ),
            (
                "gap", variables.gap,
                "Space between windows. Change in General."
            ),
            ("halfGap", variables.gap / 2, "Half of gap."),
            (
                "stageManager", variables.stageManager,
                "Left-hand space reserved for Stage Manager. Change in General."
            ),
            (
                "step", variables.step,
                "A configurable size to use as you wish. Change in General."
            ),
        ]
    }

    /// Evaluates `expression` against a representative screen size, so the value shown next to a
    /// field matches what the preview above is showing.
    private func evaluationResult(for expression: String) -> (
        value: Double?, error: String?
    ) {
        guard !expression.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (nil, nil)
        }

        do {
            let value = try rect.eval(
                expression,
                with: InsetRect.constants(for: previewFrame)
            )
            return (Double(value), nil)
        } catch {
            return (nil, "\(error)")
        }
    }

    private func fieldTitle(_ side: InsetSide) -> String {
        switch side {
        case .top: "Top"
        case .bottom: "Bottom"
        case .left: "Left"
        case .right: "Right"
        }
    }

    private func binding(for side: InsetSide) -> Binding<String> {
        switch side {
        case .top: $rect.top
        case .bottom: $rect.bottom
        case .left: $rect.left
        case .right: $rect.right
        }
    }

    private func insertVariable(_ name: String) {
        let target = binding(for: lastFocusedField)
        let current = target.wrappedValue

        target.wrappedValue = current.isEmpty ? name : current + " " + name
    }

    private init(
        _ existing: Layout? = nil,
        _ onSave: @escaping (Layout) -> Void,
        _ onDelete: (() -> Void)? = nil
    ) {
        _name = State(initialValue: existing?.name ?? "")
        _rect = State(initialValue: existing?.rect ?? .init("padding"))
        _shortcut = State(initialValue: existing?.shortcut)

        self.existing = existing
        self.onSave = onSave
        self.onDelete = onDelete
    }

    init(onSave: @escaping (Layout) -> Void) {
        self.init(nil, onSave, nil)
    }

    init(
        existing: Layout,
        onSave: @escaping (Layout) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.init(existing, onSave, onDelete)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(existing == nil ? "New Layout" : "Edit Layout")
                .font(.title2.bold())
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 8)

            Form {
                formContent
            }
            .formStyle(.grouped)
            .onChange(of: focusedField) { _, newValue in
                if let newValue {
                    lastFocusedField = newValue
                }
            }
        }
        .frame(minWidth: 600, idealHeight: 680)
        .confirmationDialog(
            "Delete “\(existing?.name ?? "")”?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                onDelete?()
                dismiss()
            }
        } message: {
            Text("This can’t be undone.")
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let id = existing?.id ?? UUID()
                    let layout = Layout(id: id, name: name, rect: rect)

                    ShortcutsManager.shared.set(shortcut, actor: layout)

                    onSave(layout)
                    dismiss()
                }
                .disabled(
                    name.trimmingCharacters(in: .whitespaces).isEmpty
                        || !rect.valid
                )
            }
        }
    }

    @ViewBuilder
    private var formContent: some View {
        Section {
            TextField("Name", text: $name, prompt: Text("Layout name"))

            KeyboardShortcuts.Recorder("Shortcut", shortcut: $shortcut)
                .shortcutValidation {
                    ShortcutsManager.shared.validateShortcut(
                        $0,
                        excluding: existing?.id ?? UUID()
                    )
                }
        }

        Section {
            HStack {
                Spacer()
                LayoutPreviewView(insetRect: rect, focusedEdge: focusedEdge)
                    .animation(.snappy, value: rect)
                Spacer()
            }
            .padding(.vertical, 8)
        } header: {
            HStack {
                Text("Preview")

                Spacer()

                if existing == nil {
                    Menu("Start from a Preset") {
                        ForEach(Self.presets, id: \.name) { preset in
                            Button(preset.name) {
                                rect = preset.rect
                            }
                        }
                    }
                    .controlSize(.small)
                }
            }
        }

        Section {
            let topResult = evaluationResult(for: rect.top)
            let bottomResult = evaluationResult(for: rect.bottom)
            let leftResult = evaluationResult(for: rect.left)
            let rightResult = evaluationResult(for: rect.right)

            ExpressionField(
                "Top",
                text: $rect.top,
                evaluatedValue: topResult.value,
                errorMessage: topResult.error,
                focus: $focusedField,
                field: InsetSide.top
            )
            ExpressionField(
                "Bottom",
                text: $rect.bottom,
                evaluatedValue: bottomResult.value,
                errorMessage: bottomResult.error,
                focus: $focusedField,
                field: InsetSide.bottom
            )
            ExpressionField(
                "Left",
                text: $rect.left,
                evaluatedValue: leftResult.value,
                errorMessage: leftResult.error,
                focus: $focusedField,
                field: InsetSide.left
            )
            ExpressionField(
                "Right",
                text: $rect.right,
                evaluatedValue: rightResult.value,
                errorMessage: rightResult.error,
                focus: $focusedField,
                field: InsetSide.right
            )

            DisclosureGroup("More info", isExpanded: $showVariablesBox) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(
                        "Each expression is the distance from that edge of the screen to the window. Tap a variable to insert it into “\(fieldTitle(lastFocusedField))”."
                    )
                    .foregroundStyle(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(variableChips, id: \.name) { chip in
                                VariableChip(
                                    name: chip.name,
                                    value: chip.value,
                                    help: chip.help
                                ) {
                                    insertVariable(chip.name)
                                }
                            }
                        }
                    }

                    Text("Supports + - * / and parentheses.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
        } header: {
            Text("Inset configuration")
        }

        if existing != nil {
            Section {
                HStack {
                    Spacer()

                    Button("Delete Layout…", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
        }
    }
}

#Preview {
    LayoutFormView { _ in }
}

