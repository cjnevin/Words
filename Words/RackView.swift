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

    @ViewBuilder
    var tileViews: some View {
        ForEach(tiles) { tile in
            TileView(tile: tile)
        }
    }
    
    var body: some View {
        device.isLandscape
            ? AnyView(VStack { tileViews })
            : AnyView(HStack { tileViews })
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
