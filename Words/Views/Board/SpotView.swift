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
    var onSelection: () -> Void

    var body: some View {
        let innerView = spot.backgroundColor
            .overlay(spot.text.minimumScaleFactor(0.01))
            .shadow(color: spot.lineColor, radius: 1, x: 0, y: 0)
        if spot.interactive {
            return AnyView(Button(action: onSelection) {
                innerView
            })
        } else {
            return AnyView(innerView)
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var spot: Spot {
        return Spot(row: 0, column: 0, middle: false, multiplier: 1, wordMultiplier: 1, tile: .init(face: "A", value: 1))
    }

    static var previews: some View {
        VStack {
            SpotView(spot: spot, onSelection: { }).colorScheme(.dark)
            
            SpotView(spot: spot, onSelection: { }).colorScheme(.light)
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
            return Text(LocalizedStringKey(name))
                .font(.caption)
                .foregroundColor(foregroundColor)
        } else {
            return Text("")
        }
    }

    var backgroundColor: Color {
        if name == "tile" {
            switch status {
            case .valid: return Color("validTile")
            case .invalid: return Color("invalidTile")
            default: return Color(name)
            }
        } else {
            return Color(name)
        }
    }

    var foregroundColor: Color {
        if name == "tile", status.contains(.fixed), status.contains(.valid) {
            return Color("recentTileForeground")
        } else {
            return Color(name + "Foreground")
        }
    }

    var lineColor: Color {
        return Color(name + "Line")
    }
}
