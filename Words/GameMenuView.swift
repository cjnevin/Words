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
        let canSubmit: Bool
        let exchange: () -> Void
        let shuffle: () -> Void
        let skip: () -> Void
        let submit: () -> Void
    }

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        Props(
            canSubmit: state.canSubmit,
            exchange: { send(RackAction.Exchange.Begin()) },
            shuffle: { send(RackAction.Shuffle()) },
            skip: { send(TurnAction.Skip()) },
            submit: { send(TurnAction.Submit()) }
        )
    }

    func body(props: Props) -> some View {
        Stack(verticalIfPortrait: false, spacing: 20) {
            Button(action: props.exchange) {
                VStack {
                    Image(systemName: "arrow.swap")
                    Text("Swap").font(.callout)
                }
            }
            Button(action: props.shuffle) {
                VStack {
                    Image(systemName: "shuffle")
                    Text("Shuffle").font(.callout)
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
                    Image(systemName: "paperplane.fill")
                    Text("Submit").font(.callout)
                }
            }.disabled(!props.canSubmit)
        }.padding()
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
