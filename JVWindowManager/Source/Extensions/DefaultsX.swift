//
//  DefaultsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults

extension Defaults.Keys {
    static let variables = Defaults.Key<Variables>(
        "_variables",
        default: Variables.default
    )

    static let layouts = Defaults.Key<[Layout]>("_layouts", default: [])

    static let sizes = Defaults.Key<Sizes>("sizes", default: Sizes.default)

    static let customLayouts = Defaults.Key<[CustomLayout]>(
        "customLayouts",
        default: []
    )

    static let customActions = Defaults.Key<[CustomAction]>(
        "customActions",
        default: []
    )
}
