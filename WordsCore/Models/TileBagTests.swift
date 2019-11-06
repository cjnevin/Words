//
//  TileBagTests.swift
//  wordsTests
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class TileBagTests: XCTestCase {
    func testTileBagEmptyReturnsNil() {
        var bag = TileBag()
        XCTAssertNil(bag.takeOne())
    }

    func testTileBagReturnsSingleItemThenIsEmpty() {
        var bag = TileBag(tiles: [.a])
        XCTAssertNotNil(bag.takeOne())
        XCTAssertNil(bag.takeOne())
    }

    func testTileBagReturnsRandomItem() {
        var bag1: TileBag!
        var bag2: TileBag!
        var equal = true
        while equal {
            bag1 = TileBag(tiles: [.a, .b, .c])
            bag2 = TileBag(tiles: [.a, .b, .c])
            equal = bag1.takeOne() == bag2.takeOne()
        }
        XCTAssertNotEqual(bag1.tiles, bag2.tiles)
    }
}
