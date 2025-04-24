//
//  ViewX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

extension View {    
    func accessibilityPermissionPrompt() -> some View {
        self.modifier(AccessibilityPermissionPromptModifier())
    }

    func inlineCode(_ textStyle: Font.TextStyle = .body) -> some View {
        self.modifier(InlineCodeModifier(textStyle: textStyle))
    }
}
