//
//  GeneralView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import Defaults
import LaunchAtLogin
import SwiftUI

struct GeneralView: View {
    @Default(.variables) private var variables: Variables

    private var accessibilityManager = AccessibilityPermissionManager.shared

    @State private var showResetVariablesConfirmation = false
    @State private var showResetLayoutsConfirmation = false
    @State private var showResetActionsConfirmation = false

    var body: some View {
        Form {
            if !accessibilityManager.isPermissionGranted {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Accessibility access required")
                                .font(.headline)

                            Text(
                                "JV Window Manager needs Accessibility access to move and resize windows. Shortcuts won't work until it's granted."
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button("Open System Settings…") {
                            accessibilityManager.requestPermission()
                            accessibilityManager.openSystemSettings()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                LaunchAtLogin.Toggle("Launch at login")

                if accessibilityManager.isPermissionGranted {
                    LabeledContent("Accessibility") {
                        Label("Granted", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                VariableRowView(
                    name: "Padding",
                    identifier: "padding",
                    caption:
                        "Space between windows and the screen edges.",
                    value: $variables.padding,
                    range: 0...50,
                    defaultValue: Variables.default.padding
                ) {
                    VariableExampleBoxView(
                        kind: .padding,
                        value: variables.padding,
                    )
                }

                VariableRowView(
                    name: "Gap",
                    identifier: "gap",
                    caption:
                        "Space between adjacent windows.",
                    value: $variables.gap,
                    range: 0...50,
                    defaultValue: Variables.default.gap
                ) {
                    VariableExampleBoxView(
                        kind: .gap,
                        value: variables.gap,
                    )
                }

                VariableRowView(
                    name: "Stage manager",
                    identifier: "stageManager",
                    caption:
                        "Space reserved on the left for Stage Manager.",
                    value: $variables.stageManager,
                    range: 0...250,
                    defaultValue: Variables.default.stageManager
                ) {
                    VariableExampleBoxView(
                        kind: .stageManager,
                        value: variables.stageManager,
                    )
                }

                VariableRowView(
                    name: "Step",
                    identifier: "step",
                    caption:
                        "A custom size you can use in layout and action expressions.",
                    value: $variables.step,
                    range: 0...200,
                    defaultValue: Variables.default.step
                ) {
                    VariableExampleBoxView(
                        kind: .step,
                        value: variables.step,
                    )
                }
            } header: {
                Text("Variables")
            } footer: {
                Text("Use these names in layout and action expressions.")
            }

            Section {
                LabeledContent {
                    Button("Reset…") {
                        showResetVariablesConfirmation = true
                    }
                    .confirmationDialog(
                        "Reset all variables?",
                        isPresented: $showResetVariablesConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            Defaults[.variables] = .default
                        }

                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(
                            "Padding, gap, stage manager and step return to their original values."
                        )
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Restore default variables")

                        Text(
                            "Padding, gap, stage manager and step return to their original values."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }

                LabeledContent {
                    Button("Reset…") {
                        showResetLayoutsConfirmation = true
                    }
                    .confirmationDialog(
                        "Reset all layouts?",
                        isPresented: $showResetLayoutsConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            Defaults[.layouts] = getDefaultLayouts()
                        }

                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(
                            "Your custom layouts will be deleted and the default layouts restored. This can't be undone."
                        )
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Restore default layouts")

                        Text(
                            "Your custom layouts will be deleted and the default layouts restored."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }

                LabeledContent {
                    Button("Reset…") {
                        showResetActionsConfirmation = true
                    }
                    .confirmationDialog(
                        "Reset all actions?",
                        isPresented: $showResetActionsConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            Defaults[.actions] = getDefaultActions()
                        }

                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(
                            "Your custom actions will be deleted and the default actions restored. This can't be undone."
                        )
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Restore default actions")

                        Text(
                            "Your custom actions will be deleted and the default actions restored."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Reset")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .animation(.default, value: accessibilityManager.isPermissionGranted)
    }
}

#Preview {
    GeneralView()
}
