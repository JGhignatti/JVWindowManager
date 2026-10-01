//
//  ActionsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/05/26.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

private enum ActionEditor: Identifiable {
    case create
    case edit(Action)

    var id: String {
        switch self {
        case .create:
            "create"
        case .edit(let action):
            action.id.uuidString
        }
    }
}

struct ActionsView: View {
    @Default(.actions) private var actions: [Action]
    @State private var selection: Set<Action.ID> = []
    @State private var editor: ActionEditor?
    @State private var pendingDeletion: Set<Action.ID>?

    var body: some View {
        List(selection: $selection) {
            ForEach(actions) { action in
                ActionRowView(action: action)
            }
            .onMove { indices, newOffset in
                var copy = actions
                copy.move(fromOffsets: indices, toOffset: newOffset)

                actions = copy
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .navigationTitle("Actions")
        .navigationSubtitle("Nudge and resize windows with a shortcut")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                newActionButton
            }
        }
        .overlay {
            if actions.isEmpty {
                ContentUnavailableView(
                    "No Actions",
                    systemImage: "tray",
                    description: Text("Add an action to get started.")
                )
            }
        }
        .contextMenu(forSelectionType: Action.ID.self) { ids in
            if ids.isEmpty {
                Button("New Action") {
                    editor = .create
                }
            } else if ids.count == 1,
                let action = actions.first(where: { ids.contains($0.id) })
            {
                Button("Edit…") {
                    editor = .edit(action)
                }
                Button("Duplicate") {
                    duplicate(action)
                }
                Divider()
                Button("Delete…", role: .destructive) {
                    pendingDeletion = ids
                }
            } else {
                Button("Delete \(ids.count) Actions…", role: .destructive) {
                    pendingDeletion = ids
                }
            }
        } primaryAction: { ids in
            guard
                ids.count == 1,
                let id = ids.first,
                let action = actions.first(where: { $0.id == id })
            else {
                return
            }

            editor = .edit(action)
        }
        .onDeleteCommand {
            guard !selection.isEmpty else {
                return
            }

            pendingDeletion = selection
        }
        .confirmationDialog(
            deletionTitle,
            isPresented: Binding(
                get: { pendingDeletion != nil },
                set: { isPresented in
                    if !isPresented {
                        pendingDeletion = nil
                    }
                }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let ids = pendingDeletion {
                    delete(ids: ids)
                }

                pendingDeletion = nil
            }
        } message: {
            Text("This can’t be undone.")
        }
        .sheet(item: $editor) { editor in
            switch editor {
            case .create:
                ActionFormView { newAction in
                    actions.append(newAction)
                }
            case .edit(let action):
                ActionFormView(existing: action) { newAction in
                    if let index = actions.firstIndex(where: {
                        $0.id == newAction.id
                    }) {
                        actions[index] = newAction
                    }
                } onDelete: {
                    var copy = actions
                    copy.removeAll { $0.id == action.id }

                    actions = copy
                }
            }
        }
    }

    @ViewBuilder
    private var newActionButton: some View {
        let button = Button("New", systemImage: "plus") {
            editor = .create
        }
        .labelStyle(.titleAndIcon)

        if #available(macOS 26, *) {
            button.buttonStyle(.glassProminent)
        } else {
            button
        }
    }

    private var deletionTitle: String {
        guard let ids = pendingDeletion else {
            return ""
        }

        if ids.count == 1, let action = actions.first(where: { ids.contains($0.id) }) {
            return "Delete “\(action.name)”?"
        }

        return "Delete \(ids.count) Actions?"
    }

    private func duplicate(_ action: Action) {
        guard let index = actions.firstIndex(where: { $0.id == action.id })
        else {
            return
        }

        let copy = Action(
            name: "\(action.name) Copy",
            rect: action.rect,
            repeatBehavior: action.repeatBehavior,
            bounds: action.bounds
        )

        var updated = actions
        updated.insert(copy, at: index + 1)

        actions = updated
    }

    private func delete(ids: Set<Action.ID>) {
        var updated = actions
        updated.removeAll { ids.contains($0.id) }

        actions = updated
        selection.subtract(ids)
    }
}

#Preview {
    ActionsView()
}
