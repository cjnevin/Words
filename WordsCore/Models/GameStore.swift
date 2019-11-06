//
//  GameStore.swift
//  WordsCore
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux

public typealias GameStore = Store<GameState, GameAction, GameDependencies>
