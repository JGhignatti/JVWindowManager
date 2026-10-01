//
//  DefaultsX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 23/04/25.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let variables = Defaults.Key<Variables>(
        "_variables",
        default: .default
    )

    static let hasLoadedDefaultLayouts = Defaults.Key<Bool>(
        "_hasLoadedDefaultLayouts",
        default: false
    )
    
    static let layouts = Defaults.Key<[Layout]>("_layouts", default: [])
    
    static let hasLoadedDefaultActions = Defaults.Key<Bool>(
        "_hasLoadedDefaultActions",
        default: false
    )
    
    static let actions = Defaults.Key<[Action]>("_actions", default: [])
}
