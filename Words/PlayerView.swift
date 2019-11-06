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
            Text(player.name).font(isCurrent ? .headline : .subheadline)
            Text(String(player.score))
        }.padding(10).minimumScaleFactor(0.7).border(isCurrent ? Color.blue : Color.clear)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(isCurrent: true, player: Player(name: "Player 1", tiles: Tile.preview, score: 100))
    }
}
