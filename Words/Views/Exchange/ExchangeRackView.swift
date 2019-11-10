//
//  ExchangeRackView.swift
//  Words
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct ExchangeRackView: View {
    @EnvironmentObject var device: Device

    var tiles: [Tile]
    var selectedTiles: [Tile]
    var onTileSelection: (Tile) -> Void

    var body: some View {
        HStack() {
            ForEach(tiles) { tile in
                TileView(tile: tile, isSelected: self.selectedTiles.contains(tile)) {
                    self.onTileSelection(tile)
                }
            }
        }.frame(idealHeight: device.tileDimension,
                maxHeight: device.tileDimension)
    }
}

struct ExchangeRackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ExchangeRackView(tiles: Tile.preview, selectedTiles: [], onTileSelection: { _ in }).colorScheme(.dark)

            ExchangeRackView(tiles: Tile.preview, selectedTiles: [], onTileSelection: { _ in }).colorScheme(.light)
        }.environmentObject(Device())
    }
}
