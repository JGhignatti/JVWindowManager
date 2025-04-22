//
//  InlineCodeModifier.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 21/04/25.
//

import SwiftUI

struct InlineCodeModifier: ViewModifier {
    let textStyle: Font.TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(.system(textStyle, design: .monospaced))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
