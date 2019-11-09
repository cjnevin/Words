//
//  Bag.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct TileBag: Codable {
    var tiles: [Tile]

    public init(tiles: [Tile] = []) {
        self.tiles = tiles
    }

    public var isDepleted: Bool {
        tiles.isEmpty
    }

    init(distribution: [Int: (String, Int)]) {
        tiles = distribution.reduce(into: [], { tiles, keyValue in
            let (amount, item) = keyValue
            let (face, value) = item
            tiles += (0..<amount).reduce(into: []) {
                $0.append(Tile(id: "\(face)\($1)", face: face, value: value, movable: true))
            }
        })
    }
}

extension TileBag {
    mutating func takeOne() -> Tile? {
        if isDepleted { return nil }
        return tiles.remove(at: Int(arc4random_uniform(UInt32(tiles.count))))
    }
}
