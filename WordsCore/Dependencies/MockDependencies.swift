//
//  MockDependencies.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
@testable import WordsCore

extension GameDependencies {
    static var mocked: GameDependencies {
        return GameDependencies(
            validator: MockWordValidator()
        )
    }
}

class MockWordValidator: WordValidator {
    subscript(letters: [Character]) -> [String]? {
        return nil
    }

    var isValid: Bool = true

    func validate(word: String) -> Bool {
        return isValid
    }
}
