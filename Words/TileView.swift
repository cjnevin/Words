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
    var isSelected: Bool
    var onSelection: () -> Void

    var body: some View {
        Button(action: onSelection) {
            tile.view(isSelected: isSelected)
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(tile: Tile(face: "A", value: 1), isSelected: false, onSelection: { })
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

    func view(isSelected: Bool) -> some View {
        let suffix = isSelected ? "Selected" : ""
        let backgroundColor = Color("tile" + suffix)
        let foregroundColor = Color("tileForeground" + suffix)
        let lineColor = Color("tileLine" + suffix)

        let text = Text(face)
            .font(.largeTitle)
            .minimumScaleFactor(0.01)
            .foregroundColor(foregroundColor)

        return backgroundColor
            .overlay(text)
            .shadow(color: lineColor, radius: 1, x: 0, y: 0)
            .aspectRatio(1, contentMode: .fit)
    }
}
