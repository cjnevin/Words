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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

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
        Props(
            elements: state.substituteTiles.enumerated().map(Props.Element.init).chunked(into: device.columns),
            selection: { send(RackAction.Substitute(tile: $0)) }
        )
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

private extension Device {
    var columns: Int {
        isLandscape ? 12 : 6
    }
}
