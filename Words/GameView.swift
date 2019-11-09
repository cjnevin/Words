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
        let isExchanging: Bool
    }

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    func map(state: GameState, dispatch: @escaping (GameAction) -> Void) -> Props {
        return Props(isExchanging: state.isExchanging)
    }

    func innerBody(props: Props) -> some View {
        Stack {
            if props.isExchanging {
                ExchangeView()
            } else {
                GameMenuView()
                Stack {
                    Spacer()
                    ScoreboardView()
                    BoardView()
                    RackView()
                    Spacer()
                }
            }
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
        return StoreProvider(store: .default) {
            GameView()
        }.environmentObject(Device())
    }
}
