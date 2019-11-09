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

    private let effectQueue: DispatchQueue
    private let reducer: R
    private let dependencies: R.E.Dependencies
    private var cancellables: Set<AnyCancellable> = []

    public init(initialState: R.State, reducer: R, dependencies: R.E.Dependencies, effectQueue: DispatchQueue) {
        self.effectQueue = effectQueue
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
    }

    public func send(_ action: R.E.Action) {
        precondition(Thread.isMainThread)
        print("Action", action)
        let effect = reducer.reduce(state: &state, action: action)
        receive(effect: effect)
    }

    private func receive(effect: R.E) {
        effect.mapToAction(dependencies: dependencies)
            .subscribe(on: effectQueue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
