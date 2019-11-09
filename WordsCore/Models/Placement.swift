//
//  Placement.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Placement: Equatable, Hashable, Codable {
    var horizontal: [Spot] = []
    var vertical: [Spot] = []

    var spots: [Spot] {
        return horizontal + vertical
    }
}

extension Placement {
    func candidates(on board: Board) -> [Candidate] {
        [
            Candidate(spots: horizontal, tiles: board.tiles(at: horizontal)),
            Candidate(spots: vertical, tiles: board.tiles(at: vertical))
        ].compactMap { $0 }
    }
}
