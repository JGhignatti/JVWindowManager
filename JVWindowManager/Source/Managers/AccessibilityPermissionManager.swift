//
//  AccessibilityPermissionManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import ApplicationServices
import AppKit
import Observation

@MainActor
@Observable
final class AccessibilityPermissionManager {
    static let shared = AccessibilityPermissionManager()

    private(set) var isPermissionGranted: Bool

    private var pollingTask: Task<Void, Never>?

    private init() {
        isPermissionGranted = AXIsProcessTrusted()

        NotificationCenter.default.addObserver(
            forName: NSApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refresh()
            }
        }

        startPollingIfNeeded()
    }

    /// Re-reads the current Accessibility trust state. TCC doesn't post a notification when the
    /// user grants or revokes access, so callers that need up-to-date status (e.g. after the app
    /// regains focus) should call this explicitly.
    func refresh() {
        isPermissionGranted = AXIsProcessTrusted()
        startPollingIfNeeded()
    }

    /// Shows the system's "add to Accessibility" prompt if access hasn't been granted yet.
    func requestPermission() {
        guard !isPermissionGranted else {
            return
        }

        // `kAXTrustedCheckOptionPrompt` isn't marked Sendable, so the string literal sidesteps a
        // Swift 6 concurrency warning; its value is documented by Apple and stable.
        let options: CFDictionary =
            ["AXTrustedCheckOptionPrompt": true]
            as CFDictionary
        isPermissionGranted = AXIsProcessTrustedWithOptions(options)
        startPollingIfNeeded()
    }

    /// Opens System Settings directly to the Accessibility pane.
    func openSystemSettings() {
        guard
            let url = URL(
                string:
                    "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
            )
        else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    /// While access isn't granted, polls every second so the UI updates without requiring the app
    /// to regain focus first (there's no push notification for TCC changes).
    private func startPollingIfNeeded() {
        guard !isPermissionGranted, pollingTask == nil else {
            return
        }

        pollingTask = Task { [weak self] in
            while let self, !self.isPermissionGranted {
                try? await Task.sleep(for: .seconds(1))

                guard !Task.isCancelled else {
                    return
                }

                self.isPermissionGranted = AXIsProcessTrusted()
            }

            self?.pollingTask = nil
        }
    }
}
