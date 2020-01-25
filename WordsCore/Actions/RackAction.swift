//
//  RackAction.swift
//  WordsCore
//
//  Created by Chris on 25/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

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

    public struct Substitute: GameAction {
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

    public enum Exchange {
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
