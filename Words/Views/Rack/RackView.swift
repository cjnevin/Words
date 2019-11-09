//
//  RackView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct RackView: ConnectedView {
    typealias R = GameReducer

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    struct Props {
        let selectedTiles: [Tile]
        let unselectedTiles: [Tile]
        let toggle: (Tile) -> Void
    }

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        return Props(
            selectedTiles: state.selectedTiles,
            unselectedTiles: state.rackTiles,
            toggle: { tile in
                send(state.selectedTiles.contains(tile)
                    ? RackAction.Drop()
                    : RackAction.PickUp(tile: tile))
        })
    }

    func body(props: Props) -> some View {
        Stack(verticalIfPortrait: false, idealDimension: 50, maximumDimension: 50) {
            ForEach(props.unselectedTiles) { tile in
                TileView(tile: tile, isSelected: props.selectedTiles.contains(tile)) {
                    props.toggle(tile)
                }
            }
        }
    }
}

struct RackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StoreProvider(store: .default) {
                RackView()
            }.colorScheme(.dark)
            StoreProvider(store: .default) {
                RackView()
            }.colorScheme(.light)
        }.environmentObject(Device())
    }
}
