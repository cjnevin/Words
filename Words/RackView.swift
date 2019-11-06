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
    var tiles: [Tile]

    var body: some View {
        HStack {
            ForEach(tiles) { tile in
                TileView(tile: tile)
            }
        }
    }
}

struct RackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RackView(tiles: Tile.preview).colorScheme(.dark)

            RackView(tiles: Tile.preview).colorScheme(.light)
        }
    }
}
