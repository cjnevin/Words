//
//  SubstituteView.swift
//  Words
//
//  Created by Chris on 25/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct SubstituteView: ConnectedView {
    typealias R = GameReducer

    struct Props {
        struct Element: Identifiable {
            let id: Int
            let tile: Tile
        }
        let elements: [[Element]]
        let selection: (Tile) -> Void
    }

    @EnvironmentObject var device: Device

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        Props(elements: state.substituteTiles.enumerated().map { index, tile in
            Props.Element(id: index, tile: tile)
        }.split(whereSeparator: { $0.id % 5 == 0 }).map(Array.init), selection: { send(RackAction.Substitute(tile: $0))
        })
    }

    func innerBody(props: Props) -> some View {
        VStack(spacing: 20) {
            Spacer()
            ForEach(props.elements) { section in
                ExchangeRackView(tiles: section.map { $0.tile }, selectedTiles: [], onTileSelection: props.selection)
            }
            Spacer()
        }.padding(4)
    }

    func body(props: Props) -> some View {
        Color("background")
            .edgesIgnoringSafeArea(.all)
            .overlay(innerBody(props: props))
    }
}
