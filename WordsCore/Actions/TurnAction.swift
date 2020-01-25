//
//  TurnAction.swift
//  WordsCore
//
//  Created by Chris on 25/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

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
