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

    init(mainPlacement: Placement,
         horizontalIntersections: [Placement],
         verticalIntersections: [Placement]) {
        self.mainPlacement = mainPlacement
        self.horizontalIntersections = horizontalIntersections.filter { $0.horizontal != mainPlacement.horizontal && $0.vertical.isEmpty }
        self.verticalIntersections = verticalIntersections.filter { $0.vertical != mainPlacement.vertical && $0.horizontal.isEmpty }
    }
}

extension CompoundPlacement {
    func candidates(on board: Board) -> [Candidate] {
        return mainPlacement.candidates(on: board)
            + horizontalIntersections.flatMap { $0.candidates(on: board) }
            + verticalIntersections.flatMap { $0.candidates(on: board) }
    }
}
