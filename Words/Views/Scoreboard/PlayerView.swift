//
//  PlayerView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct PlayerNameView: View {
    var isCurrent: Bool
    var name: String

    var body: some View {
        Text(name)
            .frame(maxHeight: 20, alignment: .center)
            .font(isCurrent ? .headline : .subheadline)
            .foregroundColor(Color(isCurrent ? "playerNameCurrent" : "playerName"))
    }
}

struct PlayerScoreView: View {
    var isCurrent: Bool
    var score: Int
    var tentativeScore: Int

    var body: some View {
        Text(String(score) + (tentativeScore > 0 ? " (+\(tentativeScore))" : ""))
            .foregroundColor(Color(isCurrent ? "playerScoreCurrent" : "playerScore"))
    }
}

struct PlayerView: View {
    var isCurrent: Bool
    var tentativeScore: Int
    var player: Player

    var body: some View {
        VStack(spacing: 4) {
            PlayerNameView(isCurrent: isCurrent, name: player.name)
            PlayerScoreView(isCurrent: isCurrent, score: player.score, tentativeScore: tentativeScore)
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
                PlayerView(isCurrent: true, tentativeScore: 10, player: Player(name: "Player 1", tiles: Tile.preview, score: 100))
                PlayerView(isCurrent: false, tentativeScore: 0, player: Player(name: "Player 2", tiles: Tile.preview, score: 200))
            }.colorScheme(.dark)

            HStack {
                PlayerView(isCurrent: true, tentativeScore: 0, player: Player(name: "Player 1", tiles: Tile.preview, score: 100))
                PlayerView(isCurrent: false, tentativeScore: 0, player: Player(name: "Player 2", tiles: Tile.preview, score: 200))
            }.colorScheme(.light)
        }
    }
}
