//
//  DefaultLayout.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import KeyboardShortcuts

enum DefaultLayout: String, CaseIterable {
    case fullScreen

    case topHalf
    case bottomHalf
    case leftHalf
    case rightHalf

    case topLeftCorner
    case topRightCorner
    case bottomLeftCorner
    case bottomRightCorner

    case vCenterHalf
    case hCenterHalf

    case peekLeft
    case peekRight

    case smFullScreen

    case smTopHalf
    case smBottomHalf
    case smLeftHalf
    case smRightHalf

    case smTopLeftCorner
    case smTopRightCorner
    case smBottomLeftCorner
    case smBottomRightCorner

    case smVCenterHalf
    case smHCenterHalf

    case smPeekLeft
    case smPeekRight

    var keyboardShortcutName: KeyboardShortcuts.Name {
        switch self {
        case .fullScreen:
            return .defaultFullScreen
        case .topHalf:
            return .defaultTopHalf
        case .bottomHalf:
            return .defaultBottomHalf
        case .leftHalf:
            return .defaultLeftHalf
        case .rightHalf:
            return .defaultRightHalf
        case .topLeftCorner:
            return .defaultTopLeftCorner
        case .topRightCorner:
            return .defaultTopRightCorner
        case .bottomLeftCorner:
            return .defaultBottomLeftCorner
        case .bottomRightCorner:
            return .defaultBottomRightCorner
        case .vCenterHalf:
            return .defaultVCenterHalf
        case .hCenterHalf:
            return .defaultHCenterHalf
        case .peekLeft:
            return .defaultPeekLeft
        case .peekRight:
            return .defaultPeekRight
        case .smFullScreen:
            return .defaultSMFullScreen
        case .smTopHalf:
            return .defaultSMTopHalf
        case .smBottomHalf:
            return .defaultSMBottomHalf
        case .smLeftHalf:
            return .defaultSMLeftHalf
        case .smRightHalf:
            return .defaultSMRightHalf
        case .smTopLeftCorner:
            return .defaultSMTopLeftCorner
        case .smTopRightCorner:
            return .defaultSMTopRightCorner
        case .smBottomLeftCorner:
            return .defaultSMBottomLeftCorner
        case .smBottomRightCorner:
            return .defaultSMBottomRightCorner
        case .smVCenterHalf:
            return .defaultSMVCenterHalf
        case .smHCenterHalf:
            return .defaultSMHCenterHalf
        case .smPeekLeft:
            return .defaultSMPeekLeft
        case .smPeekRight:
            return .defaultSMPeekRight
        }
    }

    var insetRect: InsetRect {
        switch self {
        case .fullScreen:
            return .init("padding")

        case .topHalf:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "padding",
                right: "padding"
            )

        case .bottomHalf:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "padding",
                right: "padding"
            )

        case .leftHalf:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "padding",
                right: "width / 2 + halfGap"
            )

        case .rightHalf:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "width / 2 + halfGap",
                right: "padding"
            )

        case .topLeftCorner:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "padding",
                right: "width / 2 + halfGap"
            )

        case .topRightCorner:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "width / 2 + halfGap",
                right: "padding"
            )

        case .bottomLeftCorner:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "padding",
                right: "width / 2 + halfGap"
            )

        case .bottomRightCorner:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "width / 2 + halfGap",
                right: "padding"
            )

        case .vCenterHalf:
            return .init(dx: "padding", dy: "height / 4 + halfGap")

        case .hCenterHalf:
            return .init(dx: "width / 4 + halfGap", dy: "padding")

        case .peekLeft:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "peek",
                right: "padding"
            )

        case .peekRight:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "padding",
                right: "peek"
            )

        case .smFullScreen:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager",
                right: "padding"
            )

        case .smTopHalf:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "stageManager",
                right: "padding"
            )

        case .smBottomHalf:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "stageManager",
                right: "padding"
            )

        case .smLeftHalf:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager",
                right: "(width - stageManager) / 2 + halfGap"
            )

        case .smRightHalf:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager + (width - stageManager) / 2 + halfGap",
                right: "padding"
            )

        case .smTopLeftCorner:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "stageManager",
                right: "(width - stageManager) / 2 + halfGap"
            )

        case .smTopRightCorner:
            return .init(
                top: "padding",
                bottom: "height / 2 + halfGap",
                left: "stageManager + (width - stageManager) / 2 + halfGap",
                right: "padding"
            )

        case .smBottomLeftCorner:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "stageManager",
                right: "(width - stageManager) / 2 + halfGap"
            )

        case .smBottomRightCorner:
            return .init(
                top: "height / 2 + halfGap",
                bottom: "padding",
                left: "stageManager + (width - stageManager) / 2 + halfGap",
                right: "padding"
            )

        case .smVCenterHalf:
            return .init(
                top: "height / 4 + halfGap",
                bottom: "height / 4 + halfGap",
                left: "stageManager",
                right: "padding"
            )

        case .smHCenterHalf:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager + (width - stageManager) / 4 + halfGap",
                right: "(width - stageManager) / 4 + halfGap"
            )

        case .smPeekLeft:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager + peek",
                right: "padding"
            )

        case .smPeekRight:
            return .init(
                top: "padding",
                bottom: "padding",
                left: "stageManager",
                right: "peek"
            )
        }
    }
}

extension DefaultLayout: Identifiable {
    var id: String {
        rawValue
    }
}

extension DefaultLayout: CustomStringConvertible {
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
        case .topLeftCorner:
            return "Top Left Corner"
        case .topRightCorner:
            return "Top Right Corner"
        case .bottomLeftCorner:
            return "Bottom Left Corner"
        case .bottomRightCorner:
            return "Bottom Right Corner"
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
        case .smTopLeftCorner:
            return "Stage Manager Top Left Corner"
        case .smTopRightCorner:
            return "Stage Manager Top Right Corner"
        case .smBottomLeftCorner:
            return "Stage Manager Bottom Left Corner"
        case .smBottomRightCorner:
            return "Stage Manager Bottom Right Corner"
        case .smVCenterHalf:
            return "Stage Manager Vert. Center Half"
        case .smHCenterHalf:
            return "Stage Manager Hor. Center Half"
        case .smPeekLeft:
            return "Stage Manager Peek Left"
        case .smPeekRight:
            return "Stage Manager Peek Right"
        }
    }
}
