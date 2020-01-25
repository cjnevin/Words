//
//  GameMenuView.swift
//  Words
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct GameMenuView: ConnectedView {
    typealias R = GameReducer

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    struct Props {
        let isGameOver: Bool
        let canReturnAll: Bool
        let canSubmit: Bool
        let newGame: () -> Void
        let exchange: () -> Void
        let returnAll: () -> Void
        let shuffle: () -> Void
        let skip: () -> Void
        let submit: () -> Void
    }

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        Props(
            isGameOver: state.isGameOver,
            canReturnAll: state.canReturnAll,
            canSubmit: state.canSubmit,
            newGame: { send(TurnAction.NewGame(players: ["Player 1", "Player 2"])) },
            exchange: { send(RackAction.Exchange.Begin()) },
            returnAll: { send(RackAction.ReturnAll()) },
            shuffle: { send(RackAction.Shuffle()) },
            skip: { send(TurnAction.Skip()) },
            submit: { send(TurnAction.Submit()) }
        )
    }

    func gameOver(props: Props) -> some View {
        Stack(verticalIfPortrait: false, spacing: 20) {
            Button(action: props.newGame) {
                VStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Game").font(device.menuFont)
                }
            }
        }.padding()
    }

    func gameInProgress(props: Props) -> some View {
        Stack(verticalIfPortrait: false, spacing: 20) {
            Button(action: props.submit) {
                VStack {
                    Image(systemName: "paperplane.fill")
                    Text("Submit").font(device.menuFont)
                }
            }.disabled(!props.canSubmit)
            Button(action: props.skip) {
                VStack {
                    Image(systemName: "arrow.uturn.right")
                    Text("Skip").font(device.menuFont)
                }
            }
            Spacer()
            Button(action: props.exchange) {
                VStack {
                    Image(systemName: "arrow.swap")
                    Text("Swap").font(device.menuFont)
                }
            }
            Button(action: props.shuffle) {
                VStack {
                    Image(systemName: "shuffle")
                    Text("Shuffle").font(device.menuFont)
                }
            }
            Button(action: props.returnAll) {
                VStack {
                    Image(systemName: "return")
                    Text("Return All").font(device.menuFont)
                }
            }.disabled(!props.canReturnAll)
        }.padding()
    }

    func body(props: Props) -> some View {
        if props.isGameOver {
            return AnyView(gameOver(props: props))
        } else {
            return AnyView(gameInProgress(props: props))
        }
    }
}

struct GameMenuView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            StoreProvider(store: .default) {
                GameMenuView()
            }.colorScheme(.dark)
            StoreProvider(store: .default) {
                GameMenuView()
            }.colorScheme(.light)
        }.environmentObject(Device())
    }
}
