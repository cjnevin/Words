//
//  CandidateValidationResult.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum CandidateValidationResult {
    case invalidCandidates([Candidate])
    case validCandidates([Candidate])
}

extension Sequence where Element == CandidateValidationResult {
    func flattened() -> CandidateValidationResult {
        reduce(into: .validCandidates([])) { current, next in
            switch (current, next) {
            case let (.validCandidates(old), .validCandidates(new)):
                current = .validCandidates(old + new)
            case let (.invalidCandidates(old), .invalidCandidates(new)):
                current = .invalidCandidates(old + new)
            case (.invalidCandidates, _):
                break
            case (_, .invalidCandidates):
                current = next
            }
        }
    }
}
