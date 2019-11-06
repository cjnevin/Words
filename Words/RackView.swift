//
//  RackView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct RackView: View {
    @EnvironmentObject var device: Device

    var tiles: [Tile]
    var selectedTile: Tile?
    var onTileSelection: (Tile) -> Void

    var body: some View {
        Stack(verticalIfPortrait: false) {
            ForEach(tiles) { tile in
                TileView(tile: tile, isSelected: tile == self.selectedTile) {
                    self.onTileSelection(tile)
                }
            }
        }
    }
}

struct RackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RackView(tiles: Tile.preview, onTileSelection: { _ in }).colorScheme(.dark)

            RackView(tiles: Tile.preview, onTileSelection: { _ in }).colorScheme(.light)
        }.environmentObject(Device())
    }
}
