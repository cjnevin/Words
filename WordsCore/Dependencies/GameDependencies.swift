//
//  Dependencies.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct GameDependencies {
    let backgroundDispatch: (@escaping () -> Void) -> Void
    let validator: WordValidator

    public init(
        backgroundDispatch: @escaping (@escaping () -> Void) -> Void,
        validator: WordValidator) {
        self.backgroundDispatch = backgroundDispatch
        self.validator = validator
    }
}

public protocol WordValidator {
    func validate(word: String) -> Bool
}
