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

enum Intersect {
    case withExisting
    case withMiddle
}

extension CompoundPlacement {
    init(oldBoard: Board, newBoard: Board) {
        self = oldBoard.spots.filled.compoundPlacement(newSpots: newBoard.spots.filled)
    }

    func candidates(on board: Board, intersect: Intersect) -> CandidateCollectionResult {
        let mainCandidates = mainPlacement.candidates(on: board)
        let containsMiddle = mainPlacement.spots.contains(where: { $0.middle })

        let horizontalCandidates = horizontalIntersections.map { $0.candidates(on: board) }
        let verticalCandidates = verticalIntersections.map { $0.candidates(on: board) }
        let intersections = horizontalCandidates + verticalCandidates

        print(mainPlacement.spots.compactMap { $0.tile?.face })
        print(horizontalIntersections.map { $0.spots.compactMap { $0.tile?.face } })
        print(verticalIntersections.map { $0.spots.compactMap { $0.tile?.face } })

        switch (intersect, intersections.isEmpty, containsMiddle) {
        case (.withMiddle, true, true):
            return mainCandidates
        case (.withExisting, false, false):
            return ([mainCandidates] + intersections).flattened()
        default:
            return .invalidPlacements([mainPlacement])
        }
    }
}
