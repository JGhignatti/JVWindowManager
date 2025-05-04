//
//  CustomLayoutFormView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 24/04/25.
//

import KeyboardShortcuts
import SwiftUI

struct CustomLayoutFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var insetRect: InsetRect
    @State private var shortcut: KeyboardShortcuts.Shortcut?

    @State private var showVariablesPopover = false

    private let existing: CustomLayout?
    private let onSave: (CustomLayout) -> Void

    private var tmpKeyboardShortcutsName = KeyboardShortcuts.Name(
        UUID().uuidString
    )

    init(
        existing: CustomLayout? = nil,
        onSave: @escaping (CustomLayout) -> Void
    ) {
        _name = State(initialValue: existing?.name ?? "")
        _insetRect = State(
            initialValue: existing?.insetRect
                ?? .init(
                    top: "height / 8 + halfGap",
                    bottom: "height / 4 + gap",
                    left: "stageManager",
                    right: "width / 4"
                )
        )

        if let layout = existing,
            let shortcut = KeyboardShortcuts.getShortcut(
                for: layout.keyboardShortcutsName
            )
        {
            _shortcut = State(initialValue: shortcut)
            tmpKeyboardShortcutsName.shortcut = shortcut
        }

        self.existing = existing
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HStack {
                    Text(
                        existing == nil
                            ? "Create custom layout" : "Edit custom layout"
                    )
                    .font(.title3)
                    Spacer()
                }

                GroupBox {
                    HStack {
                        Text("Name")
                        Spacer(minLength: 16)
                        TextField("Layout name", text: $name)
                            .textFieldStyle(.plain)
                            .bold()
                            .font(.title3)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                GroupBox {
                    VStack {
                        HStack {
                            Text("Inset configuration")
                            Spacer()
                        }

                        HStack(spacing: 20) {
                            VStack {
                                Text("Preview")
                                LayoutPreviewView(insetRect: insetRect)
                            }

                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Top")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Top", text: $insetRect.top)
                                        .textFieldStyle(.roundedBorder)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Bottom")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Bottom", text: $insetRect.bottom)
                                        .textFieldStyle(.roundedBorder)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Left")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Left", text: $insetRect.left)
                                        .textFieldStyle(.roundedBorder)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Right")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Right", text: $insetRect.right)
                                        .textFieldStyle(.roundedBorder)
                                }

                                HStack {
                                    Spacer()
                                    Button("Variables") {
                                        withAnimation {
                                            showVariablesPopover.toggle()
                                        }
                                    }
                                    .font(.caption)
                                    .buttonStyle(.link)
                                    .popover(
                                        isPresented: $showVariablesPopover,
                                        arrowEdge: .bottom
                                    ) {
                                        HStack(alignment: .top, spacing: 12) {
                                            VStack(
                                                alignment: .leading,
                                                spacing: 4
                                            ) {
                                                Text("Variables")

                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("width").inlineCode(
                                                        .footnote
                                                    )
                                                    Text("and")
                                                    Text("height").inlineCode(
                                                        .footnote
                                                    )
                                                    Text("The screen size")
                                                }
                                                .padding(.leading)

                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("padding").inlineCode(
                                                        .footnote
                                                    )
                                                    Text(
                                                        "The configured padding size"
                                                    )
                                                }
                                                .padding(.leading)

                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("gap").inlineCode(
                                                        .footnote
                                                    )
                                                    Text("and")
                                                    Text("halfGap").inlineCode(
                                                        .footnote
                                                    )
                                                    Text(
                                                        "Following the configured gap size"
                                                    )
                                                }
                                                .padding(.leading)

                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("stageManager")
                                                        .inlineCode(.footnote)
                                                    Text(
                                                        "The configured stage manager size"
                                                    )
                                                }
                                                .padding(.leading)

                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("peek").inlineCode(
                                                        .footnote
                                                    )
                                                    Text(
                                                        "The configured peek size"
                                                    )
                                                }
                                                .padding(.leading)
                                            }

                                            Spacer()
                                        }
                                        .padding()
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 8)
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                GroupBox {
                    HStack {
                        Text("Shortcut")
                        Spacer()
                        KeyboardShortcuts.Recorder(
                            for: tmpKeyboardShortcutsName
                        ) { shortcut in
                            self.shortcut = shortcut
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            .contentMargins(20, for: .scrollContent)

            Divider()

            HStack {
                Spacer()

                Button("Cancel", role: .cancel) {
                    dismiss()
                }

                Button(existing == nil ? "Create" : "Save") {
                    KeyboardShortcuts.disable(tmpKeyboardShortcutsName)

                    var id: UUID
                    if let existing = existing {
                        id = existing.id

                        KeyboardShortcuts.Name(id.uuidString).shortcut =
                            shortcut
                    } else {
                        id = UUID()

                        let _ = KeyboardShortcuts.Name(
                            id.uuidString,
                            default: shortcut
                        )
                    }

                    let layout = CustomLayout(
                        id: id,
                        name: name,
                        insetRect: insetRect
                    )

                    onSave(layout)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    name.trimmingCharacters(in: .whitespaces).isEmpty
                        || !insetRect.valid || shortcut == nil
                )
            }
            .padding()
        }
        .onDisappear {
            KeyboardShortcuts.disable(tmpKeyboardShortcutsName)
        }
    }
}

#Preview {
    CustomLayoutFormView { _ in }
}
