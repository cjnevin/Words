//
//  PlacementCollectionResult.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

enum PlacementError: Int, Error, Codable, Equatable, CaseIterable {
    case tileNotPlaced
    case tileMisaligned
    case tileCannotIntersectOnFirstPlay
    case tileMustIntersectMiddle
    case tileMustIntersectExistingTile
}

typealias PlacementResult = Result<CompoundPlacement, PlacementError>
