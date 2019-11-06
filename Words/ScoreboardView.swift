//
//  ScoreboardView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct ScoreboardView: View {
    @EnvironmentObject var device: Device
    var players: [Player]
    var current: Player

    @ViewBuilder
    var playerViews: some View {
        ForEach(players) { player in
            PlayerView(isCurrent: player == self.current, player: player)
        }
    }

    var body: some View {
        (device.isLandscape
            ? AnyView(VStack(spacing: 10) { playerViews })
            : AnyView(HStack(spacing: 10) { playerViews })
        ).background(Color("background"))
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        let player1 = Player(name: "Player 1", tiles: Tile.preview, score: 100)
        let player2 = Player(name: "Player 2", tiles: Tile.preview, score: 250)
        let player3 = Player(name: "Player 3", tiles: Tile.preview, score: 50)
        let player4 = Player(name: "Player 4", tiles: Tile.preview, score: 5)
        let player5 = Player(name: "Player 5", tiles: Tile.preview, score: 500)
        let player6 = Player(name: "Player 6", tiles: Tile.preview, score: 300)

        func makeScoreboardView() -> ScoreboardView {
            ScoreboardView(
                players: [player1, player2, player3, player4, player5, player6],
                current: player2
            )
        }

        return VStack(spacing: 10) {
            makeScoreboardView().colorScheme(.dark)
            makeScoreboardView().colorScheme(.light)
        }
    }
}
