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

public enum RackAction {
    public struct Place: GameAction {
        let spot: Spot

        public init(at spot: Spot) {
            self.spot = spot
        }
    }

    public struct Drop: GameAction {
        public init() { }
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

    public struct Exchange {
        public struct Begin: GameAction {
            public init() { }
        }
        public struct Toggle: GameAction {
            let tile: Tile

            public init(tile: Tile) {
                self.tile = tile
            }
        }
        public struct End: GameAction {
            public init() { }
        }
        public struct Cancel: GameAction {
            public init() { }
        }
    }
}

public enum TurnAction {
    public struct NewGame: GameAction {
        let players: [String]
        let layout: Board.Layout
        let tileDistribution: TileBag.Distribution
        
        public init(
            players: [String],
            layout: Board.Layout = Board.defaultLayout,
            tileDistribution: TileBag.Distribution = TileBag.defaultDistribution) {
            self.players = players
            self.layout = layout
            self.tileDistribution = tileDistribution
        }
    }

    public struct Skip: GameAction {
        public init() { }
    }

    public struct Submit: GameAction {
        public init() { }
    }
}

enum ValidationAction {
    struct Incorrect: GameAction {
        let candidates: [Candidate]
    }

    struct Invalid: GameAction {
        let error: PlacementError
    }

    struct Valid: GameAction {
        let score: Int
    }
}
