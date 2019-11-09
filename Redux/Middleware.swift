//
//  Middleware.swift
//  Redux
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public protocol Middleware {
    associatedtype Action
    associatedtype State
    associatedtype Dependencies

    func before(action: Action, currentState: State, dependencies: Dependencies)
    func after(action: Action, newState: State, dependencies: Dependencies)
}

extension Middleware {
    public func eraseToAnyMiddleware() -> AnyMiddleware<Action, State, Dependencies> {
        AnyMiddleware(self)
    }
}

public struct AnyMiddleware<Action, State, Dependencies> {
    @usableFromInline
    internal let box: MiddlewareBoxBase<Action, State, Dependencies>

    @inlinable
    public init<M: Middleware>(_ middleware: M) where Action == M.Action, State == M.State, Dependencies == M.Dependencies {
        box = MiddlewareBox(base: middleware)
    }
}

extension AnyMiddleware: Middleware {
    @inlinable
    public func before(action: Action, currentState: State, dependencies: Dependencies) {
        box.before(action: action, currentState: currentState, dependencies: dependencies)
    }

    @inlinable
    public func after(action: Action, newState: State, dependencies: Dependencies) {
        box.after(action: action, newState: newState, dependencies: dependencies)
    }
}

@usableFromInline
internal class MiddlewareBoxBase<Action, State, Dependencies>: Middleware {
    @inlinable
    internal init() {}

    @usableFromInline
    func before(action: Action, currentState: State, dependencies: Dependencies) {
        abstractMethod()
    }
    @usableFromInline
    func after(action: Action, newState: State, dependencies: Dependencies) {
        abstractMethod()
    }
}

@usableFromInline
internal final class MiddlewareBox<M: Middleware>
    : MiddlewareBoxBase<M.Action, M.State, M.Dependencies>
{
    @usableFromInline
    internal let base: M

    @inlinable
    internal init(base: M) {
        self.base = base
        super.init()
    }

    @inlinable
    override func before(action: Action, currentState: State, dependencies: Dependencies) {
        base.before(action: action, currentState: currentState, dependencies: dependencies)
    }

    @inlinable
    override func after(action: Action, newState: State, dependencies: Dependencies) {
        base.after(action: action, newState: newState, dependencies: dependencies)
    }
}
