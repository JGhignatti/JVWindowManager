//
//  CustomLayoutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 18/04/25.
//

import SwiftUI

struct CustomLayoutsView: View {
    @State private var customLayoutShortcuts = SettingsManager.shared
        .customLayoutShortcuts
    @State private var showCreateSheet = false

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button("Create new", systemImage: "plus") {
                    showCreateSheet = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .sheet(isPresented: $showCreateSheet) {
                    CreateLayoutSheetView()
                }
            }
            
            GroupBox {
                VStack {
                    if customLayoutShortcuts.isEmpty {
                        HStack {
                            Spacer()
                            Text("No custom layouts defined yet.")
                                .foregroundStyle(.secondary)
                                .padding(8)
                            Spacer()
                        }
                    } else {
                        ForEach(customLayoutShortcuts) { layoutShortcut in
                            LayoutShortcutRowView(
                                layoutShortcut: layoutShortcut,
                                showDivider: customLayoutShortcuts.firstIndex {
                                    $0.id == layoutShortcut.id
                                } != customLayoutShortcuts.count - 1
                            )
                        }
                    }
                }
                .padding(4)
            }
        }
        .contentMargins(.all, 16, for: .scrollContent)
    }
}

#Preview {
    CustomLayoutsView()
}
