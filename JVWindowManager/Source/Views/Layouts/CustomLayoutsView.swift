//
//  CustomLayoutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 18/04/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

private enum CustomLayoutsNavigation: Hashable {
    case create
    case edit(CustomLayout)
}

struct CustomLayoutsView: View {
    @Default(.customLayouts) private var customLayouts: [CustomLayout]
    @State private var path: [CustomLayoutsNavigation] = []
    @State private var activePreviewPopover: UUID?
    @State private var activeRemoveAlert: UUID?

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                HStack {
                    Text("Custom layouts")
                        .font(.title3)
                    Spacer()
                    Button("Create new") {
                        path.append(.create)
                    }
                    .buttonStyle(.borderedProminent)
                }

                GroupBox {
                    VStack {
                        if customLayouts.isEmpty {
                            HStack {
                                Spacer()
                                Text("No custom layouts yet.")
                                Spacer()
                            }
                        } else {
                            ForEach(customLayouts) { layout in
                                CustomLayoutsRowView(
                                    layout: layout,
                                    onEdit: {
                                        path.append(.edit(layout))
                                    },
                                    onDelete: {
                                        var layouts = Defaults[.customLayouts]
                                        withAnimation {
                                            layouts.removeAll {
                                                $0.id == layout.id
                                            }
                                        }
                                        Defaults[.customLayouts] = layouts

                                        KeyboardShortcuts.disable(
                                            layout.keyboardShortcutsName
                                        )
                                    }
                                )

                                if customLayouts.last?.id != layout.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .contentMargins(20, for: .scrollContent)
            .navigationDestination(for: CustomLayoutsNavigation.self) {
                destination in
                switch destination {
                case .create:
                    CustomLayoutFormView { newLayout in
                        Defaults[.customLayouts].append(newLayout)

                        path.removeLast()
                    }
                case .edit(let layout):
                    CustomLayoutFormView(existing: layout) { newLayout in
                        if let i = Defaults[.customLayouts].firstIndex(where: {
                            $0.id == newLayout.id
                        }) {
                            var layouts = Defaults[.customLayouts]
                            layouts[i] = newLayout
                            Defaults[.customLayouts] = layouts
                        }

                        path.removeLast()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomLayoutsView()
}
