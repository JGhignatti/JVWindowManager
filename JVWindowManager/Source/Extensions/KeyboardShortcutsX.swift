//
//  KeyboardShortcutsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    // MARK: Default shortcuts
    static let defaultFullScreen = Self(
        "defaultFullScreen",
        default: .init(.return, modifiers: [.control, .option])
    )
    static let defaultTopHalf = Self(
        "defaultTopHalf",
        default: .init(.upArrow, modifiers: [.control, .option])
    )
    static let defaultBottomHalf = Self(
        "defaultBottomHalf",
        default: .init(.downArrow, modifiers: [.control, .option])
    )
    static let defaultLeftHalf = Self(
        "defaultLeftHalf",
        default: .init(.leftArrow, modifiers: [.control, .option])
    )
    static let defaultRightHalf = Self(
        "defaultRightHalf",
        default: .init(.rightArrow, modifiers: [.control, .option])
    )
    static let defaultVCenterHalf = Self(
        "defaultVCenterHalf",
        default: .init(.v, modifiers: [.control, .option])
    )
    static let defaultHCenterHalf = Self(
        "defaultHCenterHalf",
        default: .init(.h, modifiers: [.control, .option])
    )
    static let defaultPeekLeft = Self(
        "defaultPeekLeft",
        default: .init(.o, modifiers: [.control, .option])
    )
    static let defaultPeekRight = Self(
        "defaultPeekRight",
        default: .init(.p, modifiers: [.control, .option])
    )

    // MARK: Default Stage Manager shortcuts
    static let defaultSMFullScreen = Self(
        "defaultSMFullScreen",
        default: .init(.return, modifiers: [.control, .option, .shift])
    )
    static let defaultSMTopHalf = Self(
        "defaultSMTopHalf",
        default: .init(.upArrow, modifiers: [.control, .option, .shift])
    )
    static let defaultSMBottomHalf = Self(
        "defaultSMBottomHalf",
        default: .init(.downArrow, modifiers: [.control, .option, .shift])
    )
    static let defaultSMLeftHalf = Self(
        "defaultSMLeftHalf",
        default: .init(.leftArrow, modifiers: [.control, .option, .shift])
    )
    static let defaultSMRightHalf = Self(
        "defaultSMRightHalf",
        default: .init(.rightArrow, modifiers: [.control, .option, .shift])
    )
    static let defaultSMVCenterHalf = Self(
        "defaultSMVCenterHalf",
        default: .init(.v, modifiers: [.control, .option, .shift])
    )
    static let defaultSMHCenterHalf = Self(
        "defaultSMHCenterHalf",
        default: .init(.h, modifiers: [.control, .option, .shift])
    )
    static let defaultSMPeekLeft = Self(
        "defaultSMPeekLeft",
        default: .init(.o, modifiers: [.control, .option, .shift])
    )
    static let defaultSMPeekRight = Self(
        "defaultSMPeekRight",
        default: .init(.p, modifiers: [.control, .option, .shift])
    )
}
