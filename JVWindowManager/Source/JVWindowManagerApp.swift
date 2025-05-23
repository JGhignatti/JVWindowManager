//
//  JVWindowManagerApp.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

@main
struct JVWindowManagerApp: App {
    @State private var shortcutState = ShortcutState()
    @State private var windowDelegate = SettingsWindowDelegate()

    var body: some Scene {
        Window("JV Window Manager", id: K.WindowId.Settings) {
            SettingsView()
                .accessibilityPermissionPrompt()
                .background(
                    WindowAccessor { window in
                        window.identifier = NSUserInterfaceItemIdentifier(
                            K.WindowId.Settings
                        )
                        window.delegate = windowDelegate
                    }
                )
        }
        .defaultSize(width: 800, height: 460)
        .windowResizability(.contentSize)

        MenuBarExtra(
            "JV Window Manager",
            systemImage: "inset.filled.lefthalf.topright.bottomright.rectangle"
        ) {
            MenuBarExtraView()
        }
    }
}

@MainActor
@Observable
private final class ShortcutState {
    init() {
        Task {
            for await _ in Defaults.updates(.customLayouts, initial: false) {
                registerAllShortcuts()
            }
        }

        registerAllShortcuts()
    }

    private func registerAllShortcuts() {
        KeyboardShortcuts.removeAllHandlers()

        DefaultLayout.allCases.forEach { layout in
            KeyboardShortcuts.onKeyDown(for: layout.keyboardShortcutName) {
                LayoutManager.shared.trigger(layout.insetRect)
            }
        }

        Defaults[.customLayouts].forEach { layout in
            KeyboardShortcuts.onKeyDown(for: layout.keyboardShortcutsName) {
                LayoutManager.shared.trigger(layout.insetRect)
            }
        }
        
        DefaultAction.allCases.forEach { action in
            KeyboardShortcuts.onKeyDown(for: action.keyboardShortcutName) {
                ActionManager.shared.trigger(action.actionRect)
            }
        }
        
        Defaults[.customActions].forEach { action in
            KeyboardShortcuts.onKeyDown(for: action.keyboardShortcutsName) {
                ActionManager.shared.trigger(action.actionRect)
            }
        }
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

private class SettingsWindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
