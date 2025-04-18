//
//  ViewX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import SwiftUI

extension View {
    func identifyWindow(_ id: String) -> some View {
        self.modifier(IdentifyWindowModifier(identifier: id))
    }
}
