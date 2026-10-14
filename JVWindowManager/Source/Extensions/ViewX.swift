//
//  ViewX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

extension View {
    func inlineCode(_ textStyle: Font.TextStyle = .body) -> some View {
        self.modifier(InlineCodeModifier(textStyle: textStyle))
    }

    /// Adds an invisible toolbar item so tabs without toolbar actions keep the
    /// same title bar height (and traffic-light position) as the ones with them.
    func toolbarPlaceholder() -> some View {
        toolbar {
            if #available(macOS 26, *) {
                ToolbarItem(placement: .primaryAction) {
                    ToolbarPlaceholderView()
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .primaryAction) {
                    ToolbarPlaceholderView()
                }
            }
        }
    }
}

private struct ToolbarPlaceholderView: View {
    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .accessibilityHidden(true)
    }
}
