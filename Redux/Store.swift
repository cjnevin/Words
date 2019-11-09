//
//  Store.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine

internal func abstractMethod(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Abstract method call", file: file, line: line)
}

public final class Store<R: Reducer>: ObservableObject {
    @Published public private(set) var state: R.State

    private let effectQueue: DispatchQueue
    private let reducer: R
    private let dependencies: R.E.Dependencies
    private var middlewares: [AnyMiddleware<R.E.Action, R.State, R.E.Dependencies>]
    private var cancellables: Set<AnyCancellable> = []

    public init(initialState: R.State, reducer: R, dependencies: R.E.Dependencies, effectQueue: DispatchQueue) {
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
        self.effectQueue = effectQueue
        self.middlewares = []
    }

    public func add<M: Middleware>(middleware: M) where M.Action == R.E.Action, M.State == R.State, M.Dependencies == R.E.Dependencies {
        middlewares.append(middleware.eraseToAnyMiddleware())
    }

    public func send(_ action: R.E.Action) {
        precondition(Thread.isMainThread)
        middlewares.forEach { $0.before(action: action, currentState: state, dependencies: dependencies) }
        let effect = reducer.reduce(state: &state, action: action)
        middlewares.forEach { $0.after(action: action, newState: state, dependencies: dependencies) }
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
