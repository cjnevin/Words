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

public enum BagAction {
    public struct Reset: GameAction {
        let distribution: [Int: (String, Int)]
    }
}

public enum RackAction {
    public struct Place: GameAction {
        let spot: Spot

        public init(at spot: Spot) {
            self.spot = spot
        }
    }

    public struct PickUp: GameAction {
        let tile: Tile

        public init(tile: Tile) {
            self.tile = tile
        }
    }

    public struct Return: GameAction {
        let spot: Spot

        public init(from spot: Spot) {
            self.spot = spot
        }
    }

    public struct ReturnAll: GameAction {
        public init() { }
    }

    public struct Shuffle: GameAction {
        public init() { }
    }
}

public enum TurnAction {
    public struct Exchange: GameAction {
        let tiles: [Tile]
    }
    
    public struct Skip: GameAction {
        public init() { }
    }

    public struct Submit: GameAction {
        public init() { }
    }
}

enum ValidationAction {
    struct Invalid: GameAction {
        let error: PlacementError
    }

    struct Valid: GameAction {
        let score: Int
    }
}
