//
//  KeyboardShortcutsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    // MARK: Default layouts
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
    static let defaultTopLeftCorner = Self(
        "defaultTopLeftCorner",
        default: .init(.u, modifiers: [.control, .option])
    )
    static let defaultTopRightCorner = Self(
        "defaultTopRightCorner",
        default: .init(.i, modifiers: [.control, .option])
    )
    static let defaultBottomLeftCorner = Self(
        "defaultBottomLeftCorner",
        default: .init(.j, modifiers: [.control, .option])
    )
    static let defaultBottomRightCorner = Self(
        "defaultBottomRightCorner",
        default: .init(.k, modifiers: [.control, .option])
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
    static let defaultSMTopLeftCorner = Self(
        "defaultSMTopLeftCorner",
        default: .init(.u, modifiers: [.control, .option, .shift])
    )
    static let defaultSMTopRightCorner = Self(
        "defaultSMTopRightCorner",
        default: .init(.i, modifiers: [.control, .option, .shift])
    )
    static let defaultSMBottomLeftCorner = Self(
        "defaultSMBottomLeftCorner",
        default: .init(.j, modifiers: [.control, .option, .shift])
    )
    static let defaultSMBottomRightCorner = Self(
        "defaultSMBottomRightCorner",
        default: .init(.k, modifiers: [.control, .option, .shift])
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

    // MARK: Default actions
    static let defaultPlusFull = Self(
        "defaultPlusFull",
        default: .init(.equal, modifiers: [.control, .option, .command])
    )
    static let defaultPlusHorizontal = Self(
        "defaultPlusHorizontal",
        default: .init(.d, modifiers: [.control, .option, .command])
    )
    static let defaultPlusVertical = Self(
        "defaultPlusVertical",
        default: .init(.w, modifiers: [.control, .option, .command])
    )
    static let defaultMinusFull = Self(
        "defaultMinusFull",
        default: .init(.minus, modifiers: [.control, .option, .command])
    )
    static let defaultMinusHorizontal = Self(
        "defaultMinusHorizontal",
        default: .init(.a, modifiers: [.control, .option, .command])
    )
    static let defaultMinusVertical = Self(
        "defaultMinusVertical",
        default: .init(.s, modifiers: [.control, .option, .command])
    )
    static let defaultMoveUp = Self(
        "defaultMoveUp",
        default: .init(.upArrow, modifiers: [.control, .option, .command])
    )
    static let defaultMoveDown = Self(
        "defaultMoveDown",
        default: .init(.downArrow, modifiers: [.control, .option, .command])
    )
    static let defaultMoveLeft = Self(
        "defaultMoveLeft",
        default: .init(.leftArrow, modifiers: [.control, .option, .command])
    )
    static let defaultMoveRight = Self(
        "defaultMoveRight",
        default: .init(.rightArrow, modifiers: [.control, .option, .command])
    )
}
