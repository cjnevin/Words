//
//  ExchangeView.swift
//  Words
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct ExchangeView: ConnectedView {
    typealias R = GameReducer

    struct Props {
        let selectedTiles: [Tile]
        let unselectedTiles: [Tile]

        let exchangeToggle: (Tile) -> Void
        let exchangeEnd: () -> Void
        let exchangeCancel: () -> Void
    }

    @EnvironmentObject var device: Device

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        return Props(
            selectedTiles: state.selectedTiles,
            unselectedTiles: state.rackTiles,
            exchangeToggle: { send(RackAction.Exchange.Toggle(tile: $0)) },
            exchangeEnd: { send(RackAction.Exchange.End()) },
            exchangeCancel: { send(RackAction.Exchange.Cancel()) }
        )
    }

    func exchangeMenu(props: Props) -> some View {
        HStack(spacing: 20) {
            Button(action: props.exchangeCancel) {
                VStack {
                    Image(systemName: "xmark")
                    Text("Cancel").font(.callout)
                }
            }
            if !props.selectedTiles.isEmpty {
                Spacer()
                Button(action: props.exchangeEnd) {
                    VStack {
                        Image(systemName: "arrow.swap")
                        Text("Exchange").font(.callout)
                    }
                }
            }
        }
    }

    func exchangeContent(props: Props) -> some View {
        VStack(spacing: 20) {
            if !props.selectedTiles.isEmpty {
                Text("Tiles to exchange:").font(.headline)
            }
            ExchangeRackView(tiles: props.selectedTiles, selectedTiles: props.selectedTiles, onTileSelection: props.exchangeToggle)
            if !props.unselectedTiles.isEmpty {
                Text("Tiles to keep:").font(.headline)
            }
            ExchangeRackView(tiles: props.unselectedTiles, selectedTiles: [], onTileSelection: props.exchangeToggle)
        }
    }

    func innerBody(props: Props) -> some View {
        VStack(spacing: 20) {
            Spacer()
            exchangeContent(props: props)
            Spacer()
            exchangeMenu(props: props)
        }.padding(4)
    }

    func body(props: Props) -> some View {
        Color("background")
            .edgesIgnoringSafeArea(.all)
            .overlay(innerBody(props: props))
    }
}

