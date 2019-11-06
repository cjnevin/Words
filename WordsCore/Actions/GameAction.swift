//
//  GameAction.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine

public protocol GameAction { }

enum BagAction {
    struct Reset: GameAction {
        let distribution: [Int: (String, Int)]
    }
}

enum RackAction {
    struct Place: GameAction {
        let spot: Spot

        init(at spot: Spot) {
            self.spot = spot
        }
    }

    struct PickUp: GameAction {
        let tile: Tile
    }

    struct Return: GameAction {
        let spot: Spot
    }

    struct ReturnAll: GameAction { }

    struct Shuffle: GameAction { }
}

enum TurnAction {
    struct Exchange: GameAction {
        let tiles: [Tile]
    }
    
    struct Skip: GameAction { }

    struct Submit: GameAction { }
}

enum ValidationAction {
    struct Misplaced: GameAction {
        let placements: [Placement]
    }

    struct Invalid: GameAction {
        let candidates: [Candidate]
    }

    struct Valid: GameAction {
        let score: Int
    }
}
