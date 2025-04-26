//
//  DefaultsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults

extension Defaults.Keys {
    static let sizes = Defaults.Key<Sizes>(
        "sizes",
        default: Sizes(padding: 16, gap: 16, stageManager: 180, peek: 80)
    )
    static let customLayouts = Defaults.Key<[CustomLayout]>(
        "customLayouts",
        default: []
    )
}
