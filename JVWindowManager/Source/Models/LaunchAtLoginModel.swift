//
//  LaunchAtLoginModel.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 15/04/25.
//

import ServiceManagement

struct LaunchAtLoginModel {
    private(set) var enabled: Bool
    private(set) var error: Bool

    init() {
        self.enabled = false
        self.error = false
    }

    mutating func sync() {
        self.enabled = SMAppService.mainApp.status == .enabled
        self.error = false
    }

    mutating func change(value: Bool) {
        self.error = false

        do {
            if value {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }

            self.enabled = value
        } catch {
            self.error = true
        }
    }
}
