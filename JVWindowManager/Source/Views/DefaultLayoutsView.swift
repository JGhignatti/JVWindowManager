//
//  DefaultLayoutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import KeyboardShortcuts
import SwiftUI

struct DefaultLayoutsView: View {
    @State private var activePopover: DefaultLayout?

    var body: some View {
        ScrollView {
            GroupBox(
                label:
                    Text("Default layouts").foregroundColor(.secondary)
            ) {
                VStack {
                    ForEach(DefaultLayout.allCases) { layout in
                        HStack {
                            KeyboardShortcuts.Recorder(
                                for: layout.keyboardShortcutName
                            ) {
                                HStack {
                                    Text(layout.description)
                                    Spacer()
                                }
                            }

                            Button {
                                withAnimation {
                                    activePopover =
                                        (activePopover == layout) ? nil : layout
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.tertiary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { activePopover == layout },
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
                                    LayoutPreviewView(
                                        insetRect: layout.insetRect
                                    )

                                }
                                .padding()
                                .frame(width: 220)
                            }
                        }

                        if DefaultLayout.allCases.last?.rawValue
                            != layout.rawValue
                        {
                            Divider()
                        }
                    }
                    .padding(.vertical, 2)
                }
                .padding(8)
            }
        }
        .contentMargins(20, for: .scrollContent)
    }
}

#Preview {
    DefaultLayoutsView()
}
