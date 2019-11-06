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

    var body: some View {
        VStack(spacing: 0) {
            ForEach(board.spots) { row in
                RowView(spots: row)
            }
        }.aspectRatio(contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BoardView(board: Board(spots: .defaultLayout)).colorScheme(.dark)

            BoardView(board: Board(spots: .defaultLayout)).colorScheme(.light)
        }
    }
}
