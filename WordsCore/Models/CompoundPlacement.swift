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
    func candidates(on board: Board) -> [Candidate] {
        let mainCandidates = mainPlacement.candidates(on: board)
        let horizontalCandidates = horizontalIntersections.map { $0.candidates(on: board) }
        let verticalCandidates = verticalIntersections.map { $0.candidates(on: board) }
        let intersections = horizontalCandidates + verticalCandidates

        print("main", mainPlacement.spots.compactMap { $0.tile?.face })
        print("hz", horizontalIntersections.map { $0.spots.compactMap { $0.tile?.face } })
        print("vt", verticalIntersections.map { $0.spots.compactMap { $0.tile?.face } })

        return mainCandidates + intersections.flatMap { $0 }
    }
}
