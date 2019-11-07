//
//  Candidate.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Candidate: Equatable, Codable {
    let spots: [Spot]

    init?(spots: [Spot], tiles: [Tile]) {
        guard !spots.isEmpty, spots.count == tiles.count else {
            return nil
        }
        self.spots = zip(spots, tiles).map { spot, tile in
            Spot(row: spot.row,
                 column: spot.column,
                 middle: spot.middle,
                 multiplier: spot.multiplier,
                 wordMultiplier: spot.wordMultiplier,
                 tile: tile)
        }
    }
}

extension Candidate {
    var tiles: [Tile] {
        spots.compactMap { $0.tile }
    }

    var word: String {
        spots.compactMap { $0.tile?.face }.joined()
    }

    func validate(with validator: WordValidator) -> CandidateValidationResult {
        validator.validate(word: word) ? .validCandidates([self]) : .invalidCandidates([self])
    }

    func calculateScore(oldBoard: Board, newBoard: Board) -> Int {
        wordScore(value: letterScore(oldBoard: oldBoard, newBoard: newBoard),
                  oldBoard: oldBoard,
                  newBoard: newBoard)
    }

    private func letterScore(oldBoard: Board, newBoard: Board) -> Int {
        spots.reduce(into: 0) { score, spot in
            let oldSpot = oldBoard.spots[spot.row][spot.column]
            let newSpot = newBoard.spots[spot.row][spot.column]

            if oldSpot.tile == newSpot.tile {
                score += (newSpot.tile?.value ?? 0)
            } else {
                score += newSpot.tileScore
            }
        }
    }

    private func wordScore(value: Int, oldBoard: Board, newBoard: Board) -> Int {
        spots.reduce(into: value) { score, spot in
            let oldSpot = oldBoard.spots[spot.row][spot.column]
            let newSpot = newBoard.spots[spot.row][spot.column]

            if oldSpot.tile != newSpot.tile {
                score *= newSpot.wordMultiplier
            }
        }
    }
}

extension Sequence where Element == Candidate {
    func validate(with validator: WordValidator) -> CandidateValidationResult {
        map { $0.validate(with: validator) }.flattened()
    }

    func calculateScore(oldBoard: Board, newBoard: Board) -> Int {
        reduce(into: 0) { score, candidate in
            score += candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        }
    }
}
