//
//  TileView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct TileView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var tile: Tile

    var body: some View {
        tile.backgroundColor
            .overlay(tile.text)
            .shadow(color: tile.lineColor, radius: 1, x: 0, y: 0)
            .aspectRatio(contentMode: .fit)
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(tile: Tile(face: "A", value: 1))
    }
}

extension Tile {
    static let preview: [Tile] = [
        Tile(face: "A", value: 1),
        Tile(face: "B", value: 1),
        Tile(face: "C", value: 1),
        Tile(face: "D", value: 1),
        Tile(face: "E", value: 1),
        Tile(face: "F", value: 1),
        Tile(face: "G", value: 1)
    ]

    var text: some View {
        Text(face).font(.largeTitle).minimumScaleFactor(0.01).foregroundColor(foregroundColor)
    }

    var backgroundColor: Color {
        Color("tile")
    }

    var foregroundColor: Color {
        Color("tileForeground")
    }

    var lineColor: Color {
        Color("tileLine")
    }
}
