//
//  LayoutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 12/08/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

private enum LayoutEditor: Identifiable {
    case create
    case edit(Layout)

    var id: String {
        switch self {
        case .create:
            "create"
        case .edit(let layout):
            layout.id.uuidString
        }
    }
}

struct LayoutsView: View {
    @Default(.layouts) private var layouts: [Layout]
    @State private var selection: Set<Layout.ID> = []
    @State private var editor: LayoutEditor?
    @State private var pendingDeletion: Set<Layout.ID>?

    var body: some View {
        List(selection: $selection) {
            ForEach(layouts) { layout in
                LayoutRowView(layout: layout)
            }
            .onMove { indices, newOffset in
                var copy = layouts
                copy.move(fromOffsets: indices, toOffset: newOffset)

                layouts = copy
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .navigationTitle("Layouts")
        .navigationSubtitle("Move windows with a shortcut")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                newLayoutButton
            }
        }
        .overlay {
            if layouts.isEmpty {
                ContentUnavailableView(
                    "No Layouts",
                    systemImage: "tray",
                    description: Text("Add a layout to get started.")
                )
            }
        }
        .contextMenu(forSelectionType: Layout.ID.self) { ids in
            if ids.isEmpty {
                Button("New Layout") {
                    editor = .create
                }
            } else if ids.count == 1,
                let layout = layouts.first(where: { ids.contains($0.id) })
            {
                Button("Edit…") {
                    editor = .edit(layout)
                }
                Button("Duplicate") {
                    duplicate(layout)
                }
                Divider()
                Button("Delete…", role: .destructive) {
                    pendingDeletion = ids
                }
            } else {
                Button("Delete \(ids.count) Layouts…", role: .destructive) {
                    pendingDeletion = ids
                }
            }
        } primaryAction: { ids in
            guard
                ids.count == 1,
                let id = ids.first,
                let layout = layouts.first(where: { $0.id == id })
            else {
                return
            }

            editor = .edit(layout)
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
                LayoutFormView { newLayout in
                    layouts.append(newLayout)
                }
            case .edit(let layout):
                LayoutFormView(existing: layout) { newLayout in
                    if let index = layouts.firstIndex(where: {
                        $0.id == newLayout.id
                    }) {
                        layouts[index] = newLayout
                    }
                } onDelete: {
                    var copy = layouts
                    copy.removeAll { $0.id == layout.id }

                    layouts = copy
                }
            }
        }
    }

    @ViewBuilder
    private var newLayoutButton: some View {
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

        if ids.count == 1, let layout = layouts.first(where: { ids.contains($0.id) }) {
            return "Delete “\(layout.name)”?"
        }

        return "Delete \(ids.count) Layouts?"
    }

    private func duplicate(_ layout: Layout) {
        guard let index = layouts.firstIndex(where: { $0.id == layout.id })
        else {
            return
        }

        let copy = Layout(name: "\(layout.name) Copy", rect: layout.rect)

        var updated = layouts
        updated.insert(copy, at: index + 1)

        layouts = updated
    }

    private func delete(ids: Set<Layout.ID>) {
        var updated = layouts
        updated.removeAll { ids.contains($0.id) }

        layouts = updated
        selection.subtract(ids)
    }
}

#Preview {
    LayoutsView()
}
