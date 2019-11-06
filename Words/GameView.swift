//
//  GameView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct GameView: ConnectedView {
    struct Props {
        let board: Board
        let tiles: [Tile]
    }

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var store: GameStore

    func map(state: GameState, store: GameStore) -> Props {
        return Props(
            board: state.latestBoard,
            tiles: state.currentPlayer?.tiles ?? []
        )
    }

    func body(props: Props) -> some View {
        Color("background")
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    BoardView(board: props.board)
                    RackView(tiles: props.tiles)
                }.padding(4)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return StoreProvider(store: .preview) {
            GameView()
        }
    }
}
