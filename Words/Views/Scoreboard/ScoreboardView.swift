//
//  ScoreboardView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct ScoreboardView: ConnectedView {
    typealias R = GameReducer

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    struct Props {
        let players: [Player]
        let current: Player
    }

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        Props(players: state.players,
              current: state.currentPlayer!)
    }

    @ViewBuilder
    func content(props: Props) -> some View {
        ForEach(props.players) { player in
            PlayerView(isCurrent: player == props.current, player: player)
        }
    }

    func body(props: Props) -> AnyView {
        if device.kind == .mac {
            return AnyView(VStack(spacing: 10) {
                content(props: props)
            })
        } else {
            return AnyView(Stack(verticalIfPortrait: false, spacing: 10) {
                content(props: props)
            })
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        return VStack(spacing: 10) {
            StoreProvider(store: .scoreboardPreview) {
                ScoreboardView()
            }.colorScheme(.dark)
            StoreProvider(store: .scoreboardPreview) {
                ScoreboardView()
            }.colorScheme(.light)
        }.environmentObject(Device())
    }
}

private extension GameStore {
    static var scoreboardPreview: GameStore {
        let store = GameStore(
            initialState: GameState(),
            reducer: GameReducer(),
            dependencies: .real,
            effectQueue: .global())
        store.add(middleware: ActionDebugMiddleware())
        store.send(TurnAction.NewGame(players: (0..<6).map { "Player \($0 + 1)" }))
        return store
    }
}
