//
//  Player.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Player: Codable, Equatable {
    let id: String
    public internal(set) var tiles: [Tile]
    public internal(set) var score: Int

    public init(tiles: [Tile] = [], score: Int = 0) {
        self.id = UUID().uuidString
        self.tiles = tiles
        self.score = score
    }
}

extension Player {
    mutating func remove(tiles toRemove: [Tile]) {
        for toRemove in toRemove {
            for x in 0..<tiles.count {
                if tiles[x] == toRemove {
                    tiles.remove(at: x)
                    break
                }
            }
        }
    }

    mutating func swap(tiles toRemove: [Tile], replenish: @escaping () -> Tile?) {
        remove(tiles: toRemove)
        tiles += (0..<toRemove.count).compactMap { _ in replenish() }
    }

    mutating func shuffle() {
        var bag = TileBag(tiles: tiles)
        tiles = (0..<tiles.count).compactMap { _ in bag.takeOne() }
    }
}
