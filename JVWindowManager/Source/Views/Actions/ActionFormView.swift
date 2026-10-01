//
//  ActionFormView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/05/26.
//

import Defaults
import Expression
import KeyboardShortcuts
import SwiftUI

struct ActionFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var rect: ActionRect
    @State private var repeatBehavior: ActionRepeat
    @State private var bounds: ActionBounds
    @State private var shortcut: KeyboardShortcuts.Shortcut?

    @State private var showVariablesBox = false

    @State private var showDeleteConfirmation = false

    @FocusState private var focusedField: ActionField?
    /// The last field that had focus, defaulting to Width. Variable chips insert into this field,
    /// so they keep working even right after a click moves focus away from the text field.
    @State private var lastFocusedField: ActionField = .width

    private let existing: Action?
    private let onSave: (Action) -> Void
    private let onDelete: (() -> Void)?

    /// Starting points offered to new actions, mirroring `getDefaultActions()`'s rects without its
    /// side effect of registering keyboard shortcuts.
    private static let presets: [(name: String, rect: ActionRect)] = [
        (
            "+ All sides",
            .init(
                width: "width + step",
                height: "height + step",
                x: "originX - (step / 2)",
                y: "originY - (step / 2)"
            )
        ),
        (
            "+ Horizontal",
            .init(
                width: "width + step",
                height: "height",
                x: "originX - (step / 2)",
                y: "originY"
            )
        ),
        (
            "+ Vertical",
            .init(
                width: "width",
                height: "height + step",
                x: "originX",
                y: "originY - (step / 2)"
            )
        ),
        (
            "- All sides",
            .init(
                width: "width - step",
                height: "height - step",
                x: "originX + (step / 2)",
                y: "originY + (step / 2)"
            )
        ),
        (
            "- Horizontal",
            .init(
                width: "width - step",
                height: "height",
                x: "originX + (step / 2)",
                y: "originY"
            )
        ),
        (
            "- Vertical",
            .init(
                width: "width",
                height: "height - step",
                x: "originX",
                y: "originY + (step / 2)"
            )
        ),
        ("Move up", .init(width: "width", height: "height", x: "originX", y: "originY - step")),
        ("Move down", .init(width: "width", height: "height", x: "originX", y: "originY + step")),
        ("Move left", .init(width: "width", height: "height", x: "originX - step", y: "originY")),
        ("Move right", .init(width: "width", height: "height", x: "originX + step", y: "originY")),
    ]

    private var variableChips: [(name: String, value: Int, help: String)] {
        let variables = Defaults[.variables]
        let sample = ActionPreviewView.sampleWindowFrame

        return [
            ("width", Int(sample.width), "The window's current width."),
            ("height", Int(sample.height), "The window's current height."),
            (
                "originX", Int(sample.origin.x),
                "The window's current left edge, from the screen's left edge."
            ),
            (
                "originY", Int(sample.origin.y),
                "The window's current top edge, from the screen's top edge."
            ),
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

    /// Evaluates `expression` against a representative window frame, so the value shown next to a
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
                with: ActionRect.constants(for: ActionPreviewView.sampleWindowFrame)
            )
            return (Double(value), nil)
        } catch {
            return (nil, "\(error)")
        }
    }

    private func binding(for field: ActionField) -> Binding<String> {
        switch field {
        case .width: $rect.width
        case .height: $rect.height
        case .x: $rect.x
        case .y: $rect.y
        }
    }

    private func insertVariable(_ name: String) {
        let target = binding(for: lastFocusedField)
        let current = target.wrappedValue

        target.wrappedValue = current.isEmpty ? name : current + " " + name
    }

    private init(
        _ existing: Action? = nil,
        _ onSave: @escaping (Action) -> Void,
        _ onDelete: (() -> Void)? = nil
    ) {
        _name = State(initialValue: existing?.name ?? "")
        _rect = State(
            initialValue: existing?.rect
                ?? .init(width: "width", height: "height", x: "originX", y: "originY")
        )
        _repeatBehavior = State(initialValue: existing?.repeatBehavior ?? .default)
        _bounds = State(initialValue: existing?.bounds ?? .default)
        _shortcut = State(initialValue: existing?.shortcut)

        self.existing = existing
        self.onSave = onSave
        self.onDelete = onDelete
    }

    init(onSave: @escaping (Action) -> Void) {
        self.init(nil, onSave, nil)
    }

    init(
        existing: Action,
        onSave: @escaping (Action) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.init(existing, onSave, onDelete)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(existing == nil ? "New Action" : "Edit Action")
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
        .frame(minWidth: 600, idealHeight: 780)
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
                    let action = Action(
                        id: id,
                        name: name,
                        rect: rect,
                        repeatBehavior: repeatBehavior,
                        bounds: bounds
                    )

                    ShortcutsManager.shared.set(shortcut, actor: action)

                    onSave(action)
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
            TextField("Name", text: $name, prompt: Text("Action name"))

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
                ActionPreviewView(actionRect: rect, focusedField: focusedField)
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
            let sample = ActionPreviewView.sampleWindowFrame
            let widthResult = evaluationResult(for: rect.width)
            let heightResult = evaluationResult(for: rect.height)
            let xResult = evaluationResult(for: rect.x)
            let yResult = evaluationResult(for: rect.y)

            ExpressionField(
                "Width",
                text: $rect.width,
                evaluatedValue: widthResult.value,
                errorMessage: widthResult.error,
                delta: widthResult.value.map { $0 - Double(sample.width) },
                focus: $focusedField,
                field: ActionField.width
            )
            ExpressionField(
                "Height",
                text: $rect.height,
                evaluatedValue: heightResult.value,
                errorMessage: heightResult.error,
                delta: heightResult.value.map { $0 - Double(sample.height) },
                focus: $focusedField,
                field: ActionField.height
            )
            ExpressionField(
                "X",
                text: $rect.x,
                evaluatedValue: xResult.value,
                errorMessage: xResult.error,
                delta: xResult.value.map { $0 - Double(sample.origin.x) },
                focus: $focusedField,
                field: ActionField.x
            )
            ExpressionField(
                "Y",
                text: $rect.y,
                evaluatedValue: yResult.value,
                errorMessage: yResult.error,
                delta: yResult.value.map { $0 - Double(sample.origin.y) },
                focus: $focusedField,
                field: ActionField.y
            )

            DisclosureGroup("More info", isExpanded: $showVariablesBox) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(
                        "Each expression sets the window's new width, height, or top-left position, evaluated from its current frame. Tap a variable to insert it into “\(lastFocusedField.title)”."
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
            Text("Expression configuration")
        }

        Section {
            Toggle("Repeat while held", isOn: $repeatBehavior.isEnabled)

            if repeatBehavior.isEnabled {
                Toggle("Use system key repeat rate", isOn: $repeatBehavior.usesSystemRate)

                if repeatBehavior.usesSystemRate {
                    Text(
                        "Follows System Settings › Keyboard › Key Repeat and Delay Until Repeat."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Initial delay")
                            Spacer()
                            Text("\(Int(repeatBehavior.delay * 1000)) ms")
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $repeatBehavior.delay, in: 0.1...1.0)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Repeat interval")
                            Spacer()
                            Text("\(Int(repeatBehavior.interval * 1000)) ms")
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $repeatBehavior.interval, in: 0.01...0.5)
                    }
                }
            }

            Picker("Screen bounds", selection: $bounds) {
                ForEach(ActionBounds.allCases, id: \.self) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.menu)

            Text(bounds.caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        } header: {
            Text("Advanced")
        }

        if existing != nil {
            Section {
                HStack {
                    Spacer()

                    Button("Delete Action…", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
        }
    }
}

#Preview {
    ActionFormView { _ in }
}

#Preview("Edit") {
    ActionFormView(
        existing: .init(
            name: "Move right",
            rect: .init(
                width: "width", height: "height", x: "originX + step", y: "originY"
            ),
            repeatBehavior: .init(
                isEnabled: true, usesSystemRate: false, delay: 0.4, interval: 0.08
            ),
            bounds: .keepVisible
        ),
        onSave: { _ in }
    ) {}
}
