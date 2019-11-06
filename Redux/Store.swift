//
//  Store.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine

public protocol Effect {
    associatedtype Action
    associatedtype Dependencies
    func mapToAction(dependencies: Dependencies) -> AnyPublisher<Action, Never>
}

public struct Reducer<State, Action> {
    let reduce: (inout State, Action) -> Void

    public init(reduce: @escaping (inout State, Action) -> Void) {
        self.reduce = reduce
    }
}

public final class Store<State, Action, Dependencies>: ObservableObject {
    @Published public private(set) var state: State

    private let dependencies: Dependencies
    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    public init(initialState: State, reducer: Reducer<State, Action>, dependencies: Dependencies) {
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
    }

    public func send(_ action: Action) {
        reducer.reduce(&state, action)
    }

    public func send<E: Effect>(_ effect: E) where E.Action == Action, E.Dependencies == Dependencies {
        effect
            .mapToAction(dependencies: dependencies)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
