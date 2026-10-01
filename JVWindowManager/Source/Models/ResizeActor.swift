//
//  ResizeActor.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 22/10/25.
//

import KeyboardShortcuts
import Foundation

protocol ResizeActor: Identifiable {
    associatedtype TRect: EvaluatableRect

    var name: String { get }
    var rect: TRect { get }

    var keyboardShortcutsName: KeyboardShortcuts.Name { get }

    @MainActor var shortcut: KeyboardShortcuts.Shortcut? { get }
}
