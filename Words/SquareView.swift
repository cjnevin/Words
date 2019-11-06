//
//  SquareView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct SquareView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var spot: Spot

    var body: some View {
        spot.backgroundColor
            .overlay(Text(spot.tile?.face ?? "").foregroundColor(spot.foregroundColor))
            .shadow(color: spot.lineColor, radius: 1, x: 0, y: 0)
    }
}

struct SquareView_Previews: PreviewProvider {
    static var spot: Spot {
        return Spot(row: 0, column: 0, middle: false, multiplier: 1, wordMultiplier: 1, tile: .init(face: "A", value: 1))
    }

    static var previews: some View {
        VStack {
            SquareView(spot: spot).colorScheme(.dark)
            
            SquareView(spot: spot).colorScheme(.light)
        }
    }
}

private extension Spot {
    private var name: String {
        if tile != nil {
            return "tile"
        }
        switch (multiplier, wordMultiplier) {
        case (1, 2) where middle: return "center"
        case (2, _): return "doubleLetter"
        case (_, 2): return "doubleWord"
        case (3, _): return "tripleLetter"
        case (_, 3): return "tripleWord"
        default: return "default"
        }
    }

    var backgroundColor: Color {
        return Color(name)
    }

    var foregroundColor: Color {
        return Color(name + "Foreground")
    }

    var lineColor: Color {
        return Color(name + "Line")
    }
}
