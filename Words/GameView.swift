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
        let players: [Player]
        let current: Player
        let board: Board
        let tiles: [Tile]
        let shuffle: () -> Void
        let skip: () -> Void
    }

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var store: GameStore

    func map(state: GameState, store: GameStore) -> Props {
        return Props(
            players: state.players,
            current: state.currentPlayer!,
            board: state.latestBoard,
            tiles: state.currentPlayer?.tiles ?? [],
            shuffle: { store.send(RackAction.Shuffle()) },
            skip: { store.send(TurnAction.Skip()) }
        )
    }

    func body(props: Props) -> some View {
        NavigationView {
            Color("background")
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        ScoreboardView(players: props.players, current: props.current)
                        BoardView(board: props.board)
                        RackView(tiles: props.tiles)
                        Spacer()
                    }.padding(4)
                )
                .navigationBarItems(trailing: HStack {
                    Button(action: props.shuffle) {
                        Image(systemName: "shuffle")
                    }
                    Button(action: props.skip) {
                        Image(systemName: "arrow.uturn.right")
                    }
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return StoreProvider(store: .preview) {
            GameView()
        }
    }
}
