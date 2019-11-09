//
//  Dependencies.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct GameDependencies {
    let validator: WordValidator

    public init(validator: WordValidator) {
        self.validator = validator
    }
}
