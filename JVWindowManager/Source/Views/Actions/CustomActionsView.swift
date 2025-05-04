//
//  CustomActionsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/04/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

private enum CustomActionsNavigation: Hashable {
    case create
    case edit(CustomAction)
}

struct CustomActionsView: View {
    @Default(.customActions) private var customActions: [CustomAction]
    @State private var path: [CustomActionsNavigation] = []
    @State private var activePreviewPopover: UUID?
    @State private var activeRemoveAlert: UUID?

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                HStack {
                    Text("Custom actions")
                        .font(.title3)
                    Spacer()
                    Button("Create new") {
                        path.append(.create)
                    }
                    .buttonStyle(.borderedProminent)
                }

                GroupBox {
                    VStack {
                        if customActions.isEmpty {
                            HStack {
                                Spacer()
                                Text("No custom actions yet.")
                                Spacer()
                            }
                        } else {
                            ForEach(customActions) { action in
                                CustomActionsRowView(
                                    action: action,
                                    onEdit: {
                                        path.append(.edit(action))
                                    },
                                    onDelete: {
                                        var actions = Defaults[.customActions]
                                        withAnimation {
                                            actions.removeAll {
                                                $0.id == action.id
                                            }
                                        }
                                        Defaults[.customActions] = actions

                                        KeyboardShortcuts.disable(
                                            action.keyboardShortcutsName
                                        )
                                    }
                                )

                                if customActions.last?.id != action.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .contentMargins(20, for: .scrollContent)
            .navigationDestination(for: CustomActionsNavigation.self) {
                destination in
                switch destination {
                case .create:
                    CustomActionFormView { newAction in
                        Defaults[.customActions].append(newAction)

                        path.removeLast()
                    }
                case .edit(let action):
                    CustomActionFormView(existing: action) { newAction in
                        if let i = Defaults[.customActions].firstIndex(where: {
                            $0.id == newAction.id
                        }) {
                            var actions = Defaults[.customActions]
                            actions[i] = newAction
                            Defaults[.customActions] = actions
                        }

                        path.removeLast()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomActionsView()
}
