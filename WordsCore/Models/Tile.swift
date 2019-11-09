//
//  Tile.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Tile: Equatable, Hashable, Codable, Identifiable {
    public let id: String
    public let face: String
    public let value: Int
    public internal(set) var movable: Bool
}

extension Tile {
    public init(face: String, value: Int, movable: Bool = true) {
        self.id = UUID().uuidString
        self.face = face
        self.value = value
        self.movable = movable
    }
}
