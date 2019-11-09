//
//  Store.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine

public final class Store<R: Reducer>: ObservableObject {
    @Published public private(set) var state: R.State

    private let reducer: R
    private let dependencies: R.E.Dependencies
    private var cancellables: Set<AnyCancellable> = []

    public init(initialState: R.State, reducer: R, dependencies: R.E.Dependencies) {
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
    }

    public func send(_ action: R.E.Action) {
        reducer.reduce(state: &state, action: action)
            .mapToAction(dependencies: dependencies)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
