//
//  Layout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import HotKey
import SwiftUI

enum Layout: String, CaseIterable, Identifiable, Codable {
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

    var id: String {
        rawValue
    }

    var modifiers: NSEvent.ModifierFlags {
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

    var name: String {
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
    
    var defaultShortcut: KeyboardShortcut {
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
        
        return .init(key: defaultKey, modifiers: modifiers)
    }

    func inset(from rect: CGRect) -> CGRect {
        let gap = CGFloat(SettingsManager.shared.gapSize)
        let halfGap = gap / 2
        let stageManager = CGFloat(SettingsManager.shared.stageManagerSize)
        let peekSize = CGFloat(SettingsManager.shared.peekSize)

        switch self {
        case .fullScreen:
            return rect.insetBy(gap)

        case .topHalf:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: rect.height / 2 + halfGap,
                left: gap
            )

        case .bottomHalf:
            return rect.insetBy(
                top: rect.height / 2 + halfGap,
                right: gap,
                bottom: gap,
                left: gap
            )

        case .leftHalf:
            return rect.insetBy(
                top: gap,
                right: rect.width / 2 + halfGap,
                bottom: gap,
                left: gap
            )

        case .rightHalf:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: gap,
                left: rect.width / 2 + halfGap
            )

        case .vCenterHalf:
            return rect.insetBy(dx: gap, dy: rect.height / 4 + halfGap)

        case .hCenterHalf:
            return rect.insetBy(dx: rect.width / 4 + halfGap, dy: gap)

        case .peekLeft:
            return rect.insetBy(
                top: gap,
                right: peekSize + gap,
                bottom: gap,
                left: gap
            )

        case .peekRight:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: gap,
                left: peekSize + gap
            )

        case .smFullScreen:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: gap,
                left: stageManager + gap
            )

        case .smTopHalf:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: rect.height / 2 + halfGap,
                left: stageManager + gap
            )

        case .smBottomHalf:
            return rect.insetBy(
                top: rect.height / 2 + halfGap,
                right: gap,
                bottom: gap,
                left: stageManager + gap
            )

        case .smLeftHalf:
            return rect.insetBy(
                top: gap,
                right: (rect.width - stageManager) / 2 + halfGap,
                bottom: gap,
                left: stageManager + gap
            )

        case .smRightHalf:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: gap,
                left: stageManager + (rect.width - stageManager) / 2 + halfGap
            )

        case .smVCenterHalf:
            return rect.insetBy(
                top: rect.height / 4 + halfGap,
                right: gap,
                bottom: rect.height / 4 + halfGap,
                left: stageManager + gap
            )

        case .smHCenterHalf:
            return rect.insetBy(
                top: gap,
                right: rect.width / 4 + halfGap,
                bottom: gap,
                left: stageManager + rect.width / 4 + halfGap
            )

        case .smPeekLeft:
            return rect.insetBy(
                top: gap,
                right: gap,
                bottom: gap,
                left: stageManager + peekSize + gap
            )

        case .smPeekRight:
            return rect.insetBy(
                top: gap,
                right: peekSize + gap,
                bottom: gap,
                left: stageManager + gap
            )
        }
    }
}
