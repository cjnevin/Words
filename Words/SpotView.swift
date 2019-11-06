//
//  SpotView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct SpotView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var spot: Spot

    var body: some View {
        spot.backgroundColor
            .overlay(spot.text.minimumScaleFactor(0.01))
            .shadow(color: spot.lineColor, radius: 1, x: 0, y: 0)
    }
}

struct SquareView_Previews: PreviewProvider {
    static var spot: Spot {
        return Spot(row: 0, column: 0, middle: false, multiplier: 1, wordMultiplier: 1, tile: .init(face: "A", value: 1))
    }

    static var previews: some View {
        VStack {
            SpotView(spot: spot).colorScheme(.dark)
            
            SpotView(spot: spot).colorScheme(.light)
        }
    }
}

private extension Spot {
    private var name: String {
        if tile != nil {
            return "tile"
        } else if middle {
            return "center"
        }
        switch (multiplier, wordMultiplier) {
        case (2, _): return "doubleLetter"
        case (_, 2): return "doubleWord"
        case (3, _): return "tripleLetter"
        case (_, 3): return "tripleWord"
        default: return "default"
        }
    }

    var text: Text {
        if let face = tile?.face {
            return Text(face)
                .font(.headline)
                .foregroundColor(foregroundColor)
        } else if multiplier + wordMultiplier > 2 {
            return Text(NSLocalizedString(name, comment: name))
                .font(.caption)
                .foregroundColor(foregroundColor)
        } else {
            return Text("")
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
