//
//  Layout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import HotKey
import SwiftUI

enum Layout: CaseIterable, Codable, CustomStringConvertible {
    case fullScreen

    case topHalf
    case bottomHalf
    case leftHalf
    case rightHalf

    case vCenterHalf
    case hCenterHalf

    case peekLeft
    case peekRight

    case smFullScreen

    case smTopHalf
    case smBottomHalf
    case smLeftHalf
    case smRightHalf

    case smVCenterHalf
    case smHCenterHalf

    case smPeekLeft
    case smPeekRight

    var description: String {
        switch self {
        case .fullScreen:
            return "Full Screen"
        case .topHalf:
            return "Top Half"
        case .bottomHalf:
            return "Bottom Half"
        case .leftHalf:
            return "Left Half"
        case .rightHalf:
            return "Right Half"
        case .vCenterHalf:
            return "Vertical Center Half"
        case .hCenterHalf:
            return "Horizontal Center Half"
        case .peekLeft:
            return "Peek Left"
        case .peekRight:
            return "Peek Right"
        case .smFullScreen:
            return "Stage Manager Full Screen"
        case .smTopHalf:
            return "Stage Manager Top Half"
        case .smBottomHalf:
            return "Stage Manager Bottom Half"
        case .smLeftHalf:
            return "Stage Manager Left Half"
        case .smRightHalf:
            return "Stage Manager Right Half"
        case .smVCenterHalf:
            return "Stage Manager V. Center Half"
        case .smHCenterHalf:
            return "Stage Manager H. Center Half"
        case .smPeekLeft:
            return "Stage Manager Peek Left"
        case .smPeekRight:
            return "Stage Manager Peek Right"
        }
    }

    var defaultKey: Key {
        switch self {
        case .fullScreen, .smFullScreen:
            return .return
        case .topHalf, .smTopHalf:
            return .upArrow
        case .bottomHalf, .smBottomHalf:
            return .downArrow
        case .leftHalf, .smLeftHalf:
            return .leftArrow
        case .rightHalf, .smRightHalf:
            return .rightArrow
        case .vCenterHalf, .smVCenterHalf:
            return .v
        case .hCenterHalf, .smHCenterHalf:
            return .h
        case .peekLeft, .smPeekLeft:
            return .o
        case .peekRight, .smPeekRight:
            return .p
        }
    }

    var defaultModifiers: NSEvent.ModifierFlags {
        switch self {
        case .fullScreen, .topHalf, .bottomHalf, .leftHalf, .rightHalf,
            .vCenterHalf, .hCenterHalf, .peekLeft, .peekRight:
            return [.control, .option]
        case .smFullScreen, .smTopHalf, .smBottomHalf, .smLeftHalf,
            .smRightHalf, .smVCenterHalf, .smHCenterHalf, .smPeekLeft,
            .smPeekRight:
            return [.shift, .control, .option]
        }
    }

    var defaultKeyCombo: KeyCombo {
        .init(key: defaultKey, modifiers: defaultModifiers)
    }

    var defaultLayoutShortcut: LayoutShortcut {
        .init(
            name: description,
            keyCombo: defaultKeyCombo,
            insetRectExpression: insetRectExpression
        )
    }

    var insetRectExpression: InsetRectExpression {
        switch self {
        case .fullScreen:
            return .init("gap")

        case .topHalf:
            return .init(
                top: "gap",
                bottom: "height / 2 + halfGap",
                left: "gap",
                right: "gap"
            )

        case .bottomHalf:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "gap",
                left: "gap",
                right: "gap"
            )

        case .leftHalf:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "gap",
                right: "width / 2 + halfGap"
            )

        case .rightHalf:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "width / 2 + halfGap",
                right: "gap"
            )

        case .vCenterHalf:
            return .init(dx: "gap", dy: "height / 4 + halfGap")

        case .hCenterHalf:
            return .init(dx: "width / 4 + halfGap", dy: "gap")

        case .peekLeft:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "peek + gap",
                right: "gap"
            )

        case .peekRight:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "gap",
                right: "peek + gap"
            )

        case .smFullScreen:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + gap",
                right: "gap"
            )

        case .smTopHalf:
            return .init(
                top: "gap",
                bottom: "height / 2 + halfGap",
                left: "stageManager + gap",
                right: "gap"
            )

        case .smBottomHalf:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "gap",
                left: "stageManager + gap",
                right: "gap"
            )

        case .smLeftHalf:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + gap",
                right: "(width - stageManager) / 2 + halfGap"
            )

        case .smRightHalf:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + (width - stageManager) / 2 + halfGap",
                right: "gap"
            )

        case .smVCenterHalf:
            return .init(
                top: "height / 4 + halfGap",
                bottom: "height / 4 + halfGap",
                left: "stageManager + gap",
                right: "gap"
            )

        case .smHCenterHalf:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + width / 4 + halfGap",
                right: "gap"
            )

        case .smPeekLeft:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + peek+  gap",
                right: "gap"
            )

        case .smPeekRight:
            return .init(
                top: "gap",
                bottom: "gap",
                left: "stageManager + gap",
                right: "peek + gap"
            )
        }
    }
}
