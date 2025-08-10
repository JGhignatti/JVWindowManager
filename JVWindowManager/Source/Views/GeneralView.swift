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

    @State private var showAlertIndex: Int?

    var body: some View {
        ScrollView {
            GroupBox {
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
                    Text("Variables").foregroundColor(.secondary)
            ) {
                VStack {
                    HStack {
                        HStack {
                            Text("Padding")

                            Button {
                                withAnimation {
                                    showAlertIndex = 0
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { showAlertIndex == 0 },
                                    set: { newValue in
                                        showAlertIndex = newValue ? 0 : nil
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text(
                                        "The space to frame the window in the screen"
                                    )
                                }
                                .padding()
                            }
                        }
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
                        HStack {
                            Text("Gap")

                            Button {
                                withAnimation {
                                    showAlertIndex = 1
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { showAlertIndex == 1 },
                                    set: { newValue in
                                        showAlertIndex = newValue ? 1 : nil
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text(
                                        "The space between windows"
                                    )
                                }
                                .padding()
                            }
                        }
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
                        HStack {
                            Text("Stage manager")

                            Button {
                                withAnimation {
                                    showAlertIndex = 2
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { showAlertIndex == 2 },
                                    set: { newValue in
                                        showAlertIndex = newValue ? 2 : nil
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text(
                                        "The left margin available for stage manager"
                                    )
                                }
                                .padding()
                            }
                        }
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
                        HStack {
                            Text("Peek")
                            
                            Button {
                                withAnimation {
                                    showAlertIndex = 3
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { showAlertIndex == 3 },
                                    set: { newValue in
                                        showAlertIndex = newValue ? 3 : nil
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text(
                                        "The space left to peek the window behind"
                                    )
                                }
                                .padding()
                            }
                        }
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

                    Divider()

                    HStack {
                        HStack {
                            Text("Step")

                            Button {
                                withAnimation {
                                    showAlertIndex = 4
                                }
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .popover(
                                isPresented: Binding(
                                    get: { showAlertIndex == 4 },
                                    set: { newValue in
                                        showAlertIndex = newValue ? 4 : nil
                                    }
                                ),
                                arrowEdge: .bottom
                            ) {
                                VStack {
                                    Text(
                                        "A configurable size that can be used as a step size for repeating actions"
                                    )
                                }
                                .padding()
                            }
                        }
                        .frame(width: 120, alignment: .leading)

                        Slider(
                            value: Binding<Double>(
                                get: {
                                    Double(sizes.step)
                                },
                                set: {
                                    sizes.step = Int($0)
                                }
                            ),
                            in: 0...200
                        )
                        .controlSize(.mini)
                        Text("\(sizes.step)")
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
