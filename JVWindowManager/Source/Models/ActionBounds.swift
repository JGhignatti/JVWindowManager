//
//  ActionBounds.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/09/26.
//

/// How far an ``Action`` is allowed to push a window off-screen when applying its rect.
enum ActionBounds: String, CaseIterable, Codable, Hashable {
    /// Lets the window hang off an edge or move onto another display, but never lets its
    /// title bar become fully unreachable.
    case keepVisible
    /// Keeps the window inside the combined area of every display.
    case allScreens
    /// Keeps the window inside its current screen's visible frame.
    case currentScreen
    /// Applies the rect as-is, aside from basic sanity checks.
    case none

    static let `default`: ActionBounds = .keepVisible

    var title: String {
        switch self {
        case .keepVisible: "Keep partly visible"
        case .allScreens: "Clamp to all screens"
        case .currentScreen: "Clamp to current screen"
        case .none: "No clamping"
        }
    }

    var caption: String {
        switch self {
        case .keepVisible:
            "The window can hang off an edge, but its title bar always stays grabbable on some screen."
        case .allScreens:
            "The window can move between displays, but never past the outer edges of your setup."
        case .currentScreen:
            "The window stays fully inside the screen it started on."
        case .none:
            "The window is moved or resized exactly as configured, with no safety limits."
        }
    }
}
