//
//  PlayerView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct PlayerView: View {
    var isCurrent: Bool
    var player: Player

    var body: some View {
        VStack(spacing: 4) {
            Text(player.name)
                .font(isCurrent ? .headline : .subheadline)
                .foregroundColor(Color(isCurrent ? "playerNameCurrent" : "playerName"))
            Text(String(player.score))
                .foregroundColor(Color(isCurrent ? "playerScoreCurrent" : "playerScore"))
        }
        .padding()
        .border(Color(isCurrent ? "playerBorderCurrent" : "playerBorder"))
        .background(Color("background"))
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            HStack {
                PlayerView(isCurrent: true, player: Player(name: "Player 1", tiles: Tile.preview, score: 100))
                PlayerView(isCurrent: false, player: Player(name: "Player 2", tiles: Tile.preview, score: 200))
            }.colorScheme(.dark)

            HStack {
                PlayerView(isCurrent: true, player: Player(name: "Player 1", tiles: Tile.preview, score: 100))
                PlayerView(isCurrent: false, player: Player(name: "Player 2", tiles: Tile.preview, score: 200))
            }.colorScheme(.light)
        }
    }
}
