//
//  KeyX.swift
//  JVWindowManager
//
//  Created by João Ghignatti on 16/04/25.
//

import HotKey

extension Key: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Key(string: raw) ?? .return
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
