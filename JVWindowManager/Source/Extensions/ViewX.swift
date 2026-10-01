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
}
