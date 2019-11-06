//
//  Board.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Board: Equatable, Hashable, Codable {
    public internal(set) var spots: [[Spot]] = []

    public init(spots: [[Spot]] = []) {
        self.spots = spots
    }
}

extension Board {
    func tile(at spot: Spot) -> Tile? {
        spots[spot.row][spot.column].tile
    }

    func tiles(at spots: [Spot]) -> [Tile] {
        spots.compactMap(tile)
    }

    func leftDiff(against: Board) -> [Spot] {
        zip(spots, against.spots).reduce(into: []) { buffer, row in
            zip(row.0, row.1).forEach { oldSpot, newSpot in
                if oldSpot != newSpot {
                    buffer.append(oldSpot)
                }
            }
        }
    }
    
    func rightDiff(against: Board) -> [Spot] {
        zip(spots, against.spots).reduce(into: []) { buffer, row in
            zip(row.0, row.1).forEach { oldSpot, newSpot in
                if oldSpot != newSpot {
                    buffer.append(newSpot)
                }
            }
        }
    }
}

public extension Sequence where Element == [Spot] {
    static var defaultLayout: [[Spot]] {
        return spots(from: [
            [5, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 2, 0, 0, 5],
            [0, 3, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 3, 0],
            [0, 0, 3, 0, 0, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0],
            [2, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 2],
            [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0],
            [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
            [0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0],
            [5, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 2, 0, 0, 5],
            [0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0],
            [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
            [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0],
            [2, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 2],
            [0, 0, 3, 0, 0, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0],
            [0, 3, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 3, 0],
            [5, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 2, 0, 0, 5]
        ])
    }

    private static func spots(from layout: [[Int]]) -> [[Spot]] {
        let middle = layout.count / 2
        return layout.enumerated().map { row, columns in
            columns.enumerated().map { column, multiplier in
                let letterMultiplier = Swift.max(1, multiplier < 4 ? multiplier : 1)
                let wordMultiplier = multiplier > 3 ? multiplier - 2 : 1
                return Spot(
                    row: row,
                    column: column,
                    middle: row == middle && column == middle,
                    multiplier: letterMultiplier,
                    wordMultiplier: wordMultiplier,
                    tile: nil)
            }
        }
    }
}
