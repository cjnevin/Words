//
//  Placement+Extensions.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
@testable import WordsCore

extension Placement {
    var spots: [Spot] {
        return horizontal + vertical
    }
}

extension CompoundPlacement {
    var mainFaces: String {
        return mainPlacement.spots.compactMap { $0.tile?.face }.joined()
    }

    var horizontalFaces: [String] {
        return horizontalIntersections.map { $0.horizontal.face }
    }

    var verticalFaces: [String] {
        return verticalIntersections.map { $0.vertical.face }
    }
}
