//
//  CustomLayoutsRowView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 26/04/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

struct CustomLayoutsRowView: View {
    let layout: CustomLayout
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteAlert = false
    @State private var showPreviewPopover = false

    var body: some View {
        HStack {
            Text(layout.name)

            Spacer()

            KeyboardShortcuts.Recorder(
                for: layout.keyboardShortcutsName
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
                "Are you sure you want to delete this layout?",
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
            .help("Preview layout")
            .popover(
                isPresented: $showPreviewPopover,
                arrowEdge: .bottom
            ) {
                VStack {
                    Text("Preview")
                    LayoutPreviewView(insetRect: layout.insetRect)
                }
                .padding()
            }
        }
        .padding(.vertical, 2)
    }
}
