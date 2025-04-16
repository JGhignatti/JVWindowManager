//
//  GeneralView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct GeneralView: View {
    @State private var launchAtLoginModel = LaunchAtLoginModel()

    @State private var gapSize = SettingsManager.shared.gapSize
    @State private var stageManagerSize = SettingsManager.shared
        .stageManagerSize
    @State private var peekSize = SettingsManager.shared.peekSize

    var body: some View {
        GeometryReader { g in
            ScrollView {
                GroupBox(
                    label: Text("Behaviors").padding(.bottom, 4)
                        .foregroundColor(.secondary)
                ) {
                    VStack {
                        HStack {
                            Text("Launch at login")
                            Spacer()
                            Toggle(
                                "",
                                isOn: Binding(
                                    get: {
                                        launchAtLoginModel.enabled
                                    },
                                    set: { value in
                                        launchAtLoginModel.change(value: value)
                                    }
                                )
                            )
                            .toggleStyle(.switch)
                        }

                        if launchAtLoginModel.error {
                            HStack {
                                Spacer()
                                Text("Error updating launch at login")
                                    .foregroundColor(.red)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(4)
                }
                .padding(.top)
                .onAppear {
                    launchAtLoginModel.sync()
                }

                GroupBox(
                    label: Text("Sizes").padding(.bottom, 4).foregroundColor(
                        .secondary
                    )
                ) {
                    VStack {
                        HStack {
                            Text("Gap size")
                            Spacer()
                            Slider(
                                value: Binding<Double>(
                                    get: { Double(gapSize) },
                                    set: { value in
                                        SettingsManager.shared.gapSize = Int(
                                            value
                                        )
                                        gapSize = Int(value)
                                    }
                                ),
                                in: 0...50
                            )
                            .frame(width: g.size.width * 0.5)
                            Text("\(gapSize)px")
                                .frame(width: 40, alignment: .trailing)
                        }
                        Divider()
                        HStack {
                            Text("Stage manager size")
                            Spacer()
                            Slider(
                                value: Binding<Double>(
                                    get: { Double(stageManagerSize) },
                                    set: { value in
                                        SettingsManager.shared
                                            .stageManagerSize = Int(value)
                                        stageManagerSize = Int(value)
                                    }
                                ),
                                in: 0...250
                            )
                            .frame(width: g.size.width * 0.5)
                            Text("\(stageManagerSize)px")
                                .frame(width: 40, alignment: .trailing)
                        }
                        Divider()
                        HStack {
                            Text("Peek size")
                            Spacer()
                            Slider(
                                value: Binding<Double>(
                                    get: { Double(peekSize) },
                                    set: { value in
                                        SettingsManager.shared
                                            .peekSize = Int(value)
                                        peekSize = Int(value)
                                    }
                                ),
                                in: 0...100
                            )
                            .frame(width: g.size.width * 0.5)
                            Text("\(peekSize)px")
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                    .padding(4)
                }
            }
            .padding(.horizontal)
        }
        .frame(minWidth: 480)
    }
}

#Preview {
    GeneralView()
}
