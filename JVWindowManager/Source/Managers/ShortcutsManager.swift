//
//  ShortcutsManager.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 20/10/25.
//

import Defaults
import KeyboardShortcuts
import SwiftUI

@MainActor
final class ShortcutsManager {
    static let shared = ShortcutsManager()

    /// Layout ids that currently have a registered key-down handler, so `sync` can diff against new state.
    private var knownLayoutIds: Set<UUID> = []
    /// Action ids that currently have a registered listener, so `sync` can diff against new state.
    private var knownActionIds: Set<UUID> = []

    /// Per-action listener for key-down/key-up events, kept so it can be cancelled when the action
    /// is removed.
    private var actionListenerTasks: [UUID: Task<Void, Never>] = [:]
    /// Per-action repeat loop, running only while that action's shortcut is held down.
    private var actionRepeatTasks: [UUID: Task<Void, Never>] = [:]

    private init() {
        // Both known-id sets must be populated before the first purge, or it would treat every
        // action as orphaned while only layouts have been reconciled yet (and vice versa).
        reconcile(layouts: Defaults[.layouts])
        reconcile(actions: Defaults[.actions])
        purgeOrphanedShortcuts()

        Task { @MainActor in
            for await layouts in Defaults.updates(.layouts, initial: false) {
                reconcile(layouts: layouts)
                purgeOrphanedShortcuts()
            }
        }

        Task { @MainActor in
            for await actions in Defaults.updates(.actions, initial: false) {
                reconcile(actions: actions)
                purgeOrphanedShortcuts()
            }
        }
    }

    func set(_ shortcut: KeyboardShortcuts.Shortcut?, actor: any ResizeActor) {
        KeyboardShortcuts.setShortcut(
            shortcut,
            for: actor.keyboardShortcutsName
        )
    }

    /// Prevents a layout and an action — or two of either — from sharing the same shortcut, since
    /// only one of them could ever fire.
    func validateShortcut(
        _ shortcut: KeyboardShortcuts.Shortcut,
        excluding id: UUID
    ) -> KeyboardShortcuts.ValidationResult {
        if let conflict = Defaults[.layouts].first(where: {
            $0.id != id && $0.shortcut == shortcut
        }) {
            return .disallow(reason: "Already used by “\(conflict.name)”.")
        }

        if let conflict = Defaults[.actions].first(where: {
            $0.id != id && $0.shortcut == shortcut
        }) {
            return .disallow(reason: "Already used by “\(conflict.name)”.")
        }

        return .allow
    }

    func delete(name: KeyboardShortcuts.Name) {
        KeyboardShortcuts.removeHandler(for: name)
        KeyboardShortcuts.setShortcut(nil, for: name)
    }

    /// Reconciles the registered layout handlers with the current `Defaults[.layouts]`. Callers are
    /// responsible for following up with `purgeOrphanedShortcuts()` once every actor type relevant
    /// to that purge pass has been reconciled.
    private func reconcile(layouts: [Layout]) {
        let currentIds = Set(layouts.map(\.id))

        for removedId in knownLayoutIds.subtracting(currentIds) {
            delete(name: .init(removedId.uuidString))
        }

        for id in currentIds.subtracting(knownLayoutIds) {
            registerLayoutHandler(id: id)
        }

        knownLayoutIds = currentIds
    }

    /// Reconciles the registered action listeners with the current `Defaults[.actions]`. Callers are
    /// responsible for following up with `purgeOrphanedShortcuts()` once every actor type relevant
    /// to that purge pass has been reconciled.
    private func reconcile(actions: [Action]) {
        let currentIds = Set(actions.map(\.id))

        for removedId in knownActionIds.subtracting(currentIds) {
            unregisterActionHandler(id: removedId)
            delete(name: .init(removedId.uuidString))
        }

        for id in currentIds.subtracting(knownActionIds) {
            registerActionHandler(id: id)
        }

        knownActionIds = currentIds
    }

    /// Registers a handler that looks up the layout's current rect at fire time, rather than capturing a
    /// snapshot of it, so edits to the layout apply without needing to re-register anything.
    private func registerLayoutHandler(id: UUID) {
        let name = KeyboardShortcuts.Name(id.uuidString)

        KeyboardShortcuts.removeHandler(for: name)

        KeyboardShortcuts.onKeyDown(for: name) {
            guard let layout = Defaults[.layouts].first(where: { $0.id == id })
            else {
                return
            }

            LayoutManager.shared.trigger(layout.rect)
        }
    }

    /// Listens for key-down/key-up on the action's name (not a fixed shortcut), so rebinding it in a
    /// `Recorder` keeps working without re-registering. Key-down triggers the action once and, if its
    /// `repeatBehavior` allows it, starts repeating; key-up stops the repeat.
    private func registerActionHandler(id: UUID) {
        let name = KeyboardShortcuts.Name(id.uuidString)

        unregisterActionHandler(id: id)

        actionListenerTasks[id] = Task { @MainActor in
            for await event in KeyboardShortcuts.events(for: name) {
                guard let action = Defaults[.actions].first(where: { $0.id == id })
                else {
                    continue
                }

                switch event {
                case .keyDown:
                    ActionManager.shared.trigger(action)
                    startRepeating(action, id: id, name: name)
                case .keyUp:
                    stopRepeating(id: id)
                }
            }
        }
    }

    private func unregisterActionHandler(id: UUID) {
        actionListenerTasks[id]?.cancel()
        actionListenerTasks[id] = nil

        stopRepeating(id: id)
    }

    /// Waits `repeatBehavior.effectiveDelay`, then re-triggers the action every
    /// `repeatBehavior.effectiveInterval` until key-up cancels this task. Re-reads the action from
    /// `Defaults` on each tick, so live edits to its rect or repeat settings apply mid-hold.
    private func startRepeating(_ action: Action, id: UUID, name: KeyboardShortcuts.Name) {
        stopRepeating(id: id)

        guard action.repeatBehavior.isEnabled else {
            return
        }

        actionRepeatTasks[id] = Task { @MainActor in
            guard let initialDelay = Defaults[.actions].first(where: { $0.id == id })?
                .repeatBehavior.effectiveDelay
            else {
                return
            }

            try? await Task.sleep(for: .seconds(initialDelay))

            while !Task.isCancelled, KeyboardShortcuts.isEnabled(for: name) {
                guard let current = Defaults[.actions].first(where: { $0.id == id })
                else {
                    return
                }

                ActionManager.shared.trigger(current)

                try? await Task.sleep(for: .seconds(current.repeatBehavior.effectiveInterval))
            }
        }
    }

    private func stopRepeating(id: UUID) {
        actionRepeatTasks[id]?.cancel()
        actionRepeatTasks[id] = nil
    }

    /// Removes any shortcut left over in `KeyboardShortcuts`' storage that no longer belongs to a
    /// known layout or action. Must only run once `knownLayoutIds` and `knownActionIds` both reflect
    /// their current `Defaults` contents, or it will wipe out whichever side hasn't reconciled yet.
    private func purgeOrphanedShortcuts() {
        let validNames: Set<String> =
            Set(knownLayoutIds.map(\.uuidString))
            .union(knownActionIds.map(\.uuidString))

        for name in KeyboardShortcuts.storedNames
        where !validNames.contains(name.rawValue) {
            KeyboardShortcuts.setShortcut(nil, for: name)
        }
    }
}
