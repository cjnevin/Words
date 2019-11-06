//
//  CompoundPlacement.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

struct CompoundPlacement: Equatable, Hashable {
    let mainPlacement: Placement
    let horizontalIntersections: [Placement]
    let verticalIntersections: [Placement]
}

extension CompoundPlacement {
    init(oldBoard: Board, newBoard: Board) {
        self = oldBoard.spots.filled.compoundPlacement(newSpots: newBoard.spots.filled)
    }

    func candidates(on board: Board) -> CandidateCollectionResult {
        let allCandidates = [mainPlacement.candidates(on: board)]
            + horizontalIntersections.map { $0.candidates(on: board) }
            + verticalIntersections.map { $0.candidates(on: board) }
        return allCandidates.flattened()
    }
}
