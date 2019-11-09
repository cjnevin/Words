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

    func map(state: GameState, dispatch: @escaping (GameAction) -> Void) -> Props {
        Props(players: state.players,
              current: state.currentPlayer!)
    }

    func body(props: Props) -> some View {
        Stack(verticalIfPortrait: false, spacing: 10) {
            ForEach(props.players) { player in
                PlayerView(isCurrent: player == props.current, player: player)
            }
        }.background(Color("background"))
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        func makeScoreboardView() -> some View {
            StoreProvider(store: .scoreboardPreview) {
                ScoreboardView()
            }
        }

        return VStack(spacing: 10) {
            makeScoreboardView().colorScheme(.dark)
            makeScoreboardView().colorScheme(.light)
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
