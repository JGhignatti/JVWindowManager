//
//  ShortcutCaptureView.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/04/25.
//

import AppKit
import HotKey
import SwiftUI

struct ShortcutCaptureView: NSViewRepresentable {
    @Binding var shortcut: KeyboardShortcut?
    var modifiers: NSEvent.ModifierFlags
    @Binding var isCapturing: Bool

    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField()
        field.isBezeled = true
        field.isEditable = false
        field.alignment = .center
        field.focusRingType = .none
        field.delegate = context.coordinator

        let gesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.focus)
        )
        field.addGestureRecognizer(gesture)

        return field
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if isCapturing {
            nsView.stringValue = "Press key..."
        } else if let shortcut = shortcut {
            nsView.stringValue = shortcut.key.description
        } else {
            nsView.stringValue = "Click to enter"
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, isCapturing: $isCapturing)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: ShortcutCaptureView
        @Binding var isCapturing: Bool

        var monitor: Any?

        init(_ parent: ShortcutCaptureView, isCapturing: Binding<Bool>) {
            self.parent = parent
            self._isCapturing = isCapturing
        }

        @objc func focus() {
            startMonitoring()
        }

        func startMonitoring() {
            stopMonitoring()

            isCapturing = true

            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
                [weak self] event in
                guard let self else { return event }

                guard let key = Key(carbonKeyCode: UInt32(event.keyCode)) else {
                    return event
                }

                self.parent.shortcut = KeyboardShortcut(
                    key: key,
                    modifiers: parent.modifiers
                )

                self.isCapturing = false
                self.stopMonitoring()

                DispatchQueue.main.async {
                    NSApp.mainWindow?.makeFirstResponder(nil)
                }

                return nil
            }
        }

        func stopMonitoring() {
            if let monitor {
                NSEvent.removeMonitor(monitor)
                self.monitor = nil
            }
        }
    }
}
