//
//  DefaultActionsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 28/04/25.
//

import KeyboardShortcuts
import SwiftUI

struct DefaultActionsView: View {
    @State private var activePopover: DefaultAction?

    var body: some View {
        ScrollView {
            HStack {
                Text("Default actions")
                    .font(.title3)
                Spacer()
            }

            GroupBox {
                VStack {
                    ForEach(DefaultAction.allCases) { action in
                        HStack {
                            KeyboardShortcuts.Recorder(
                                for: action.keyboardShortcutName
                            ) {
                                HStack {
                                    Text(action.description)
                                    Spacer()
                                }
                            }

                            Button {
                                withAnimation {
                                    activePopover =
                                        (activePopover == action) ? nil : action
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .help("Preview action")
                            .popover(
                                isPresented: Binding(
                                    get: { activePopover == action },
                                    set: { newValue in
                                        if !newValue {
                                            activePopover = nil
                                        }
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text("Preview")
                                    ActionPreviewView(
                                        actionRect: action.actionRect
                                    )
                                }
                                .padding()
                            }
                        }
                        .padding(.vertical, 2)

                        if DefaultAction.allCases.last?.rawValue
                            != action.rawValue
                        {
                            Divider()
                        }
                    }
                }
                .padding(8)
            }
        }
        .contentMargins(20, for: .scrollContent)
    }
}

#Preview {
    DefaultActionsView()
}
