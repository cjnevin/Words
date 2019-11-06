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
    @EnvironmentObject var device: Device

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

    func shuffle(props: Props) -> some View {
        Button(action: props.shuffle) {
            Image(systemName: "shuffle")
        }
    }

    func skip(props: Props) -> some View {
        Button(action: props.skip) {
            Image(systemName: "arrow.uturn.right")
        }
    }

    @ViewBuilder
    func menu(props: Props) -> some View {
        shuffle(props: props)
        Spacer()
        skip(props: props)
    }

    @ViewBuilder
    func content(props: Props) -> some View {
        Spacer()
        ScoreboardView(players: props.players, current: props.current)
        BoardView(board: props.board)
        RackView(tiles: props.tiles)
        Spacer()
    }

    func landscape(props: Props) -> some View {
        HStack {
            VStack {
                menu(props: props)
            }.padding()
            content(props: props)
        }.padding(4)
    }

    func portrait(props: Props) -> some View {
        VStack {
            HStack {
                menu(props: props)
            }.padding()
            content(props: props)
        }.padding(4)
    }

    func body(props: Props) -> some View {
        Color("background")
            .edgesIgnoringSafeArea(.all)
        .overlay(
            device.isLandscape
                ? AnyView(landscape(props: props))
                : AnyView(portrait(props: props))
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
