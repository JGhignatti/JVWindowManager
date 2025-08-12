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

            Spacer(minLength: 24)

            HStack {
                Text("Variables").font(.title2)

                Spacer()
            }
            .padding(.horizontal, 8)

            GroupBox {
                VStack {
                    VariableRowView(
                        name: "Padding",
                        caption:
                            "The space to frame the application window in the screen,\nwith value between 0 and 50.",
                        value: $variables.padding,
                        range: 0...50
                    )
                    
                    Divider()

                    VariableRowView(
                        name: "Gap",
                        caption:
                            "The space added between windows,\nwith value between 0 and 50.",
                        value: $variables.gap,
                        range: 0...50
                    )
                    
                    Divider()
                    
                    VariableRowView(
                        name: "Stage manager",
                        caption:
                            "The left-hand space left for the Stage Manager,\nwith value between 0 and 250.",
                        value: $variables.stageManager,
                        range: 0...250
                    )
                    
                    Divider()
                    
                    VariableRowView(
                        name: "Step",
                        caption:
                            "A configurable size that can be used in both layouts and actions,\nwith value between 0 and 200.",
                        value: $variables.step,
                        range: 0...200
                    )
                }
                .padding(8)
            }
            
            HStack {
                Spacer()
                
                Button {
                    Defaults.reset(.variables)
                } label: {
                    Text("Reset variables")
                }
                .buttonStyle(.link)
            }
        }
        .contentMargins(20, for: .scrollContent)
    }
}

#Preview {
    GeneralView()
}
