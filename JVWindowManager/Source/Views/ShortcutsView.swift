//
//  ShortcutsView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

struct ShortcutsView: View {
    var body: some View {
        ScrollView {
            GroupBox(
                label: Text("Shortcuts").padding(.bottom, 4)
                    .foregroundColor(.secondary)
            ) {
                VStack {
                    ForEach(Layout.allCases) { layout in
                        HStack {
                            Text("\(layout.name)")
                            Spacer()
                            Text("\(layout.modifiers) \(layout.key)")
                        }

                        if layout != Layout.allCases.last {
                            Divider()
                        }
                    }
                }.padding(4)
            }
        }
        .contentMargins(.horizontal, 32, for: .scrollContent)
        .contentMargins(.vertical, 16, for: .scrollContent)
    }
}

#Preview {
    ShortcutsView()
}
