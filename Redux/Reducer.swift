//
//  Reducer.swift
//  Redux
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public protocol Reducer {
    associatedtype State
    associatedtype E: Effect
    func reduce(state: inout State, action: E.Action) -> E
}
