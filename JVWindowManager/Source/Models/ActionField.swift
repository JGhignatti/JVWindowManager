//
//  ActionField.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 30/09/26.
//

/// One of the four expressions making up an ``ActionRect``, used to track which field is focused
/// so the preview can highlight the edges it affects.
enum ActionField: Hashable {
    case width, height, x, y

    var title: String {
        switch self {
        case .width: "Width"
        case .height: "Height"
        case .x: "X"
        case .y: "Y"
        }
    }
}
