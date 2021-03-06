//
//  BoardView.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Redux
import SwiftUI
import WordsCore

struct BoardView: ConnectedView {
    typealias R = GameReducer

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var device: Device

    struct Props {
        let rows: [[Spot]]
        let select: (Spot) -> Void
    }

    func map(state: GameState, send: @escaping (GameAction) -> Void) -> Props {
        return Props(
            rows: state.spots,
            select: {
                send($0.tile == nil ? RackAction.Place(at: $0) : RackAction.Return(from: $0))
        })
    }

    func body(props: Props) -> some View {
        VStack(spacing: 0) {
            ForEach(props.rows) { row in
                RowView(onSpotSelection: props.select, spots: row)
            }
        }.aspectRatio(1, contentMode: .fit).animation(.easeInOut(duration: 0.2))
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StoreProvider(store: .default) {
                BoardView()
            }.colorScheme(.dark)
            StoreProvider(store: .default) {
                BoardView()
            }.colorScheme(.light)
        }.environmentObject(Device())
    }
}
