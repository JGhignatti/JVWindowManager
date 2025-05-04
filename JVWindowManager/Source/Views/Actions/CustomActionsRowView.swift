//
//  CustomActionsRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/04/25.
//

import KeyboardShortcuts
import SwiftUI

struct CustomActionsRowView: View {
    let action: CustomAction
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteAlert = false
    @State private var showPreviewPopover = false

    var body: some View {
        HStack {
            Text(action.name)

            Spacer()

            KeyboardShortcuts.Recorder(
                for: action.keyboardShortcutsName
            )

            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil.circle")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Edit")

            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Image(systemName: "trash.circle")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Delete")
            .alert(
                "Are you sure you want to delete this action?",
                isPresented: $showDeleteAlert
            ) {
                Button("Delete", role: .destructive) {
                    onDelete()
                }

                Button("Cancel", role: .cancel) {
                    showDeleteAlert = false
                }
            }

            Button {
                withAnimation {
                    showPreviewPopover = true
                }
            } label: {
                Image(systemName: "questionmark.circle")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Preview action")
            .popover(
                isPresented: $showPreviewPopover,
                arrowEdge: .bottom
            ) {
                VStack {
                    Text("Preview")
                    ActionPreviewView(actionRect: action.actionRect)
                }
                .padding()
            }
        }
        .padding(.vertical, 2)
    }
}
