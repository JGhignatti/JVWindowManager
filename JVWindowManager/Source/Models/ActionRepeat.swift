//
//  ActionRepeat.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/09/26.
//

import AppKit
import Foundation

/// Governs whether holding an ``Action``'s shortcut re-triggers it, and at what pace.
struct ActionRepeat {
    static let `default`: ActionRepeat = .init()

    var isEnabled: Bool
    var usesSystemRate: Bool
    /// Seconds between the initial trigger and the first repeat.
    var delay: Double
    /// Seconds between subsequent repeats.
    var interval: Double

    init(
        isEnabled: Bool = true,
        usesSystemRate: Bool = true,
        delay: Double = 0.3,
        interval: Double = 0.05,
    ) {
        self.isEnabled = isEnabled
        self.usesSystemRate = usesSystemRate
        self.delay = delay
        self.interval = interval
    }

    /// The delay actually used when repeating, following the system's Keyboard settings unless
    /// a custom rate was requested.
    var effectiveDelay: Double {
        usesSystemRate ? NSEvent.keyRepeatDelay : delay
    }

    /// The interval actually used when repeating, following the system's Keyboard settings unless
    /// a custom rate was requested.
    var effectiveInterval: Double {
        usesSystemRate ? NSEvent.keyRepeatInterval : interval
    }
}

extension ActionRepeat: Codable, Equatable, Hashable {}
