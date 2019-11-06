//
//  BoardView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI
import WordsCore

struct BoardView: View {
    var board: Board
    var onSpotSelection: (Spot) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(board.spots) { row in
                RowView(onSpotSelection: self.onSpotSelection, spots: row)
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BoardView(board: Board(spots: .defaultLayout), onSpotSelection: { _ in }).colorScheme(.dark)

            BoardView(board: Board(spots: .defaultLayout), onSpotSelection: { _ in }).colorScheme(.light)
        }
    }
}
