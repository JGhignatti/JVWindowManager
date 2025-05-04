//
//  DefaultAction.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 28/04/25.
//

import KeyboardShortcuts

enum DefaultAction: String, CaseIterable {
    case plusFull
    case plusHorizontal
    case plusVertical

    case minusFull
    case minusHorizontal
    case minusVertical

    case moveUp
    case moveDown
    case moveLeft
    case moveRight

    var keyboardShortcutName: KeyboardShortcuts.Name {
        switch self {
        case .plusFull:
            return .defaultPlusFull
        case .plusHorizontal:
            return .defaultPlusHorizontal
        case .plusVertical:
            return .defaultPlusVertical
        case .minusFull:
            return .defaultMinusFull
        case .minusHorizontal:
            return .defaultMinusHorizontal
        case .minusVertical:
            return .defaultMinusVertical
        case .moveUp:
            return .defaultMoveUp
        case .moveDown:
            return .defaultMoveDown
        case .moveLeft:
            return .defaultMoveLeft
        case .moveRight:
            return .defaultMoveRight
        }
    }

    var actionRect: ActionRect {
        switch self {
        case .plusFull:
            return .init(
                width: "width + step",
                height: "height + step",
                x: "originX - (step / 2)",
                y: "originY - (step / 2)"
            )

        case .plusHorizontal:
            return .init(
                width: "width + step",
                height: "height",
                x: "originX - (step / 2)",
                y: "originY"
            )

        case .plusVertical:
            return .init(
                width: "width",
                height: "height + step",
                x: "originX",
                y: "originY - (step / 2)"
            )

        case .minusFull:
            return .init(
                width: "width - step",
                height: "height - step",
                x: "originX + (step / 2)",
                y: "originY + (step / 2)"
            )

        case .minusHorizontal:
            return .init(
                width: "width - step",
                height: "height",
                x: "originX + (step / 2)",
                y: "originY"
            )

        case .minusVertical:
            return .init(
                width: "width",
                height: "height - step",
                x: "originX",
                y: "originY + (step / 2)"
            )

        case .moveUp:
            return .init(
                width: "width",
                height: "height",
                x: "originX",
                y: "originY - step"
            )

        case .moveDown:
            return .init(
                width: "width",
                height: "height",
                x: "originX",
                y: "originY + step"
            )

        case .moveLeft:
            return .init(
                width: "width",
                height: "height",
                x: "originX - step",
                y: "originY",
            )

        case .moveRight:
            return .init(
                width: "width",
                height: "height",
                x: "originX + step",
                y: "originY",
            )
        }
    }
}

extension DefaultAction: Identifiable {
    var id: String {
        rawValue
    }
}

extension DefaultAction: CustomStringConvertible {
    var description: String {
        switch self {
        case .plusFull:
            return "+ All sides"
        case .plusHorizontal:
            return "+ Horizontal"
        case .plusVertical:
            return "+ Vertical"
        case .minusFull:
            return "- All sides"
        case .minusHorizontal:
            return "- Horizontal"
        case .minusVertical:
            return "- Vertical"
        case .moveUp:
            return "Move up"
        case .moveDown:
            return "Move down"
        case .moveLeft:
            return "Move left"
        case .moveRight:
            return "Move right"
        }
    }
}
