//
//  Triggerable.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 29/04/25.
//

protocol Triggerable {
    associatedtype Value

    func trigger(_ value: Value)
}
