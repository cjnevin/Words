//
//  RowView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct RowView: View {
    var spots: [Spot]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(spots) { spot in
                SquareView(spot: spot)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RowView(spots: [
                Spot(row: 0, column: 0, middle: false, multiplier: 1, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 1, middle: false, multiplier: 2, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 2, middle: false, multiplier: 1, wordMultiplier: 2, tile: nil),
                Spot(row: 0, column: 3, middle: false, multiplier: 3, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 4, middle: false, multiplier: 1, wordMultiplier: 3, tile: nil),
                Spot(row: 0, column: 5, middle: false, multiplier: 1, wordMultiplier: 1, tile: .init(face: "A", value: 1))
            ]).colorScheme(.dark)

            RowView(spots: [
                Spot(row: 0, column: 0, middle: false, multiplier: 1, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 1, middle: false, multiplier: 2, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 2, middle: false, multiplier: 1, wordMultiplier: 2, tile: nil),
                Spot(row: 0, column: 3, middle: false, multiplier: 3, wordMultiplier: 1, tile: nil),
                Spot(row: 0, column: 4, middle: false, multiplier: 1, wordMultiplier: 3, tile: nil),
                Spot(row: 0, column: 5, middle: false, multiplier: 1, wordMultiplier: 1, tile: .init(face: "A", value: 1))
            ]).colorScheme(.light)
        }
    }
}
