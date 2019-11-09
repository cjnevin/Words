//
//  Bag.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct TileBag: Codable {
    public struct Distribution {
        public struct Element {
            public let face: String
            public let value: Int
            public let amount: Int

            public init(face: String, value: Int, amount: Int) {
                self.face = face
                self.value = value
                self.amount = amount
            }

            var tiles: [Tile] {
                (0..<amount).map(tile)
            }

            func tile(at index: Int) -> Tile {
                return Tile(id: "\(face)\(index)", face: face, value: value, movable: true)
            }
        }
        let elements: [Element]
        let rack: Int
    }
    var tiles: [Tile]
    let rack: Int

    init(distribution: Distribution) {
        tiles = distribution.elements.reduce(into: [], { buffer, element in
            buffer.append(contentsOf: element.tiles)
        })
        rack = distribution.rack
    }

    public init(tiles: [Tile] = [], rack: Int = 7) {
        self.tiles = tiles
        self.rack = rack
    }

    public var isDepleted: Bool {
        tiles.isEmpty
    }

    mutating func replenish(player: inout Player) {
        player.tiles += draw(amount: rack - player.tiles.count)
    }

    private mutating func draw(amount: Int) -> [Tile] {
        (0..<amount).compactMap { _ in self.takeOne() }
    }
}

extension TileBag {
    public static var defaultDistribution: Distribution {
        return .init(elements: [
            .init(face: "?", value: 0, amount: 2),
            .init(face: "A", value: 1, amount: 9),
            .init(face: "B", value: 3, amount: 2),
            .init(face: "C", value: 3, amount: 2),
            .init(face: "D", value: 2, amount: 4),
            .init(face: "E", value: 1, amount: 12),
            .init(face: "F", value: 4, amount: 2),
            .init(face: "G", value: 2, amount: 3),
            .init(face: "H", value: 4, amount: 2),
            .init(face: "I", value: 1, amount: 9),
            .init(face: "J", value: 8, amount: 1),
            .init(face: "K", value: 5, amount: 1),
            .init(face: "L", value: 1, amount: 4),
            .init(face: "M", value: 3, amount: 2),
            .init(face: "N", value: 1, amount: 6),
            .init(face: "O", value: 1, amount: 8),
            .init(face: "P", value: 3, amount: 2),
            .init(face: "Q", value: 10, amount: 1),
            .init(face: "R", value: 1, amount: 6),
            .init(face: "S", value: 1, amount: 4),
            .init(face: "T", value: 1, amount: 6),
            .init(face: "U", value: 1, amount: 4),
            .init(face: "V", value: 4, amount: 2),
            .init(face: "W", value: 4, amount: 2),
            .init(face: "X", value: 8, amount: 1),
            .init(face: "Y", value: 4, amount: 2),
            .init(face: "Z", value: 10, amount: 1)
        ], rack: 7)
    }

    mutating func takeOne() -> Tile? {
        if isDepleted { return nil }
        return tiles.remove(at: Int(arc4random_uniform(UInt32(tiles.count))))
    }
}
