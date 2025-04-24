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
    @Default(.sizes) var sizes: Sizes

    var body: some View {
        ScrollView {
            GroupBox(
                label:
                    Text("Behaviors").foregroundColor(.secondary)
            ) {
                LaunchAtLogin.Toggle {
                    HStack {
                        Text("Launch at login")
                            .font(.body)
                        Spacer()
                    }
                }
                .toggleStyle(.switch)
                .controlSize(.small)
                .padding(8)
            }

            GroupBox(
                label:
                    Text("Sizes").foregroundColor(.secondary)
            ) {
                VStack {
                    HStack {
                        Text("Padding")
                            .frame(width: 120, alignment: .leading)

                        Slider(
                            value: Binding<Double>(
                                get: {
                                    Double(sizes.padding)
                                },
                                set: {
                                    sizes.padding = Int($0)
                                }
                            ),
                            in: 0...50
                        )
                        .controlSize(.mini)
                        Text("\(sizes.padding)")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.vertical, 4)

                    Divider()

                    HStack {
                        Text("Gap")
                            .frame(width: 120, alignment: .leading)
                        Slider(
                            value: Binding<Double>(
                                get: {
                                    Double(sizes.gap)
                                },
                                set: {
                                    sizes.gap = Int($0)
                                }
                            ),
                            in: 0...50
                        )
                        .controlSize(.mini)
                        Text("\(sizes.gap)")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.vertical, 4)

                    Divider()

                    HStack {
                        Text("Stage manager")
                            .frame(width: 120, alignment: .leading)
                        HStack {
                            Slider(
                                value: Binding<Double>(
                                    get: {
                                        Double(sizes.stageManager)
                                    },
                                    set: {
                                        sizes.stageManager = Int($0)
                                    }
                                ),
                                in: 0...250
                            )
                            .controlSize(.mini)
                            Text("\(sizes.stageManager)")
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                    .padding(.vertical, 4)

                    Divider()

                    HStack {
                        Text("Peek")
                            .frame(width: 120, alignment: .leading)
                        Slider(
                            value: Binding<Double>(
                                get: {
                                    Double(sizes.peek)
                                },
                                set: {
                                    sizes.peek = Int($0)
                                }
                            ),
                            in: 0...100
                        )
                        .controlSize(.mini)
                        Text("\(sizes.peek)")
                            .frame(width: 40, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
                .padding(8)
            }

            HStack {
                Spacer()
                Link(
                    "Need help configuring?",
                    destination: URL(
                        string:
                            "https://github.com/JGhignatti/JVWindowManager"
                    )!
                )
                .font(.caption)
            }

        }
        .contentMargins(20, for: .scrollContent)
    }
}

#Preview {
    GeneralView()
}
