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

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        return Props(isExchanging: state.isExchanging)
    }

    @ViewBuilder
    func content(props: Props) -> some View {
        if props.isExchanging {
            ExchangeView()
        } else {
            Stack {
                ScoreboardView()
                Spacer()
                BoardView()
                Spacer()
                RackView()
            }
            GameMenuView()
        }
    }

    func innerBody(props: Props) -> some View {
        if device.kind == .mac {
            return AnyView(VStack {
                content(props: props)
            }).padding(4)
        } else {
            return AnyView(Stack {
                content(props: props)
            }).padding(4)
        }
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
