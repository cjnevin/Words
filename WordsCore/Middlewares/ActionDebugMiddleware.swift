//
//  DebugMiddleware.swift
//  Words
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux

public struct ActionDebugMiddleware: Middleware {
    public init() { }
    
    public func before(action: GameAction, currentState: GameState, dependencies: GameDependencies) {
        print("🚀", "\(action)".replacingOccurrences(of: "WordsCore.", with: ""))
    }

    public func after(action: GameAction, newState: GameState, dependencies: GameDependencies) {

    }
}
