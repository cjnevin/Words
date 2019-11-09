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
    typealias R = GameReducer

    struct Props {
        let players: [Player]
        let current: Player
        let board: Board
        let heldTile: Tile?
        let tiles: [Tile]
        let canSubmit: Bool

        let tileSelection: (Tile) -> Void
        let spotSelection: (Spot) -> Void
        let shuffle: () -> Void
        let skip: () -> Void
        let submit: () -> Void
    }

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    func map(state: GameState, dispatch: @escaping (GameAction) -> Void) -> Props {
        return Props(
            players: state.players,
            current: state.currentPlayer!,
            board: state.latestBoard,
            heldTile: state.heldTile,
            tiles: state.currentPlayer?.tiles ?? [],
            canSubmit: state.canSubmit,
            tileSelection: { tile in
                dispatch(state.heldTile == tile ? RackAction.Drop() : RackAction.PickUp(tile: tile))
        },
            spotSelection: { spot in
                dispatch(spot.tile == nil ? RackAction.Place(at: spot) : RackAction.Return(from: spot))
        },
            shuffle: { dispatch(RackAction.Shuffle()) },
            skip: { dispatch(TurnAction.Skip()) },
            submit: { dispatch(TurnAction.Submit()) }
        )
    }

    func menu(props: Props) -> some View {
        Stack(verticalIfPortrait: false, spacing: 20) {
            Button(action: props.shuffle) {
                VStack {
                    Image(systemName: "shuffle")
                    Text("Shuffle").font(.callout)
                }
            }
            Button(action: props.shuffle) {
                VStack {
                    Image(systemName: "arrow.swap")
                    Text("Swap").font(.callout)
                }
            }
            Spacer()
            Button(action: props.skip) {
                VStack {
                    Image(systemName: "arrow.uturn.right")
                    Text("Skip").font(.callout)
                }
            }
            Button(action: props.submit) {
                VStack {
                    Image(systemName: "arrow.turn.up.right")
                    Text("Submit").font(.callout)
                }
            }.disabled(!props.canSubmit)
        }.padding()
    }

    func content(props: Props) -> some View {
        Stack {
            Spacer()
            ScoreboardView(players: props.players, current: props.current)
            BoardView(board: props.board, onSpotSelection: props.spotSelection)
            RackView(tiles: props.tiles, selectedTile: props.heldTile, onTileSelection: props.tileSelection)
            Spacer()
        }
    }

    func innerBody(props: Props) -> some View {
        Stack {
            menu(props: props)
            content(props: props)
        }.padding(4)
    }

    func body(props: Props) -> some View {
        Color("background")
            .edgesIgnoringSafeArea(.all)
            .overlay(innerBody(props: props))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return StoreProvider(store: .preview) {
            GameView()
        }.environmentObject(Device())
    }
}
