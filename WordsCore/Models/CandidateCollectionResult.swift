//
//  CandidateCollectionResult.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum CandidateCollectionResult {
    case invalidPlacements([Placement])
    case candidates([Candidate])
}

extension Sequence where Element == CandidateCollectionResult {
    func flattened() -> CandidateCollectionResult {
        reduce(into: .candidates([])) { current, next in
            switch (current, next) {
            case let (.candidates(old), .candidates(new)):
                current = .candidates(old + new)
            case let (.invalidPlacements(old), .invalidPlacements(new)):
                current = .invalidPlacements(old + new)
            case (.invalidPlacements, _):
                break
            case (_, .invalidPlacements):
                current = next
            }
        }
    }
}
