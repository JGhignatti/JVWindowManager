//
//  CustomActionFormView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 02/05/25.
//

import KeyboardShortcuts
import SwiftUI

struct CustomActionFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var actionRect: ActionRect
    @State private var shortcut: KeyboardShortcuts.Shortcut?

    @State private var showVariablesPopover = false

    private let existing: CustomAction?
    private let onSave: (CustomAction) -> Void

    private var tmpKeyboardShortcutsName = KeyboardShortcuts.Name(
        K.tmpKeyboardShortcutsName
    )

    init(
        existing: CustomAction? = nil,
        onSave: @escaping (CustomAction) -> Void
    ) {
        _name = State(initialValue: existing?.name ?? "")
        _actionRect = State(
            initialValue: existing?.actionRect
                ?? .init(
                    width: "width + step * 4",
                    height: "height",
                    x: "originX",
                    y: "originY + step * 2"
                )
        )

        if let action = existing,
            let shortcut = KeyboardShortcuts.getShortcut(
                for: action.keyboardShortcutsName
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
                            ? "Create custom action" : "Edit custom action"
                    )
                    .font(.title3)
                    Spacer()
                }

                GroupBox {
                    HStack {
                        Text("Name")
                        Spacer(minLength: 16)
                        TextField("Action name", text: $name)
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
                            Text("Action configuration")
                            Spacer()
                        }

                        HStack(spacing: 20) {
                            VStack {
                                Text("Preview")
                                ActionPreviewView(actionRect: actionRect)
                            }

                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Width")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Width", text: $actionRect.width)
                                        .textFieldStyle(.roundedBorder)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Height")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField(
                                        "Height",
                                        text: $actionRect.height
                                    )
                                    .textFieldStyle(.roundedBorder)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("X")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("X", text: $actionRect.x)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Y")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                    TextField("Y", text: $actionRect.y)
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
                                                    Text("The window size")
                                                }
                                                .padding(.leading)
                                                
                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("originX").inlineCode(
                                                        .footnote
                                                    )
                                                    Text("and")
                                                    Text("originY").inlineCode(
                                                        .footnote
                                                    )
                                                    Text("The window position")
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
                                                
                                                HStack(
                                                    alignment: .top,
                                                    spacing: 8
                                                ) {
                                                    Text("•")
                                                    Text("step").inlineCode(
                                                        .footnote
                                                    )
                                                    Text(
                                                        "The configured step size"
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

                    let action = CustomAction(
                        id: id,
                        name: name,
                        actionRect: actionRect
                    )

                    onSave(action)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    name.trimmingCharacters(in: .whitespaces).isEmpty
                        || !actionRect.valid || shortcut == nil
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
    CustomActionFormView { _ in }
}
