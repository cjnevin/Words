//
//  ValidationAction.swift
//  WordsCore
//
//  Created by Chris on 25/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

enum ValidationAction {
    struct Incorrect: GameAction {
        let candidates: [Candidate]
    }

    struct Invalid: GameAction {
        let error: PlacementError
    }

    struct Valid: GameAction {
        let score: Int
        let candidates: [Candidate]
    }
}
