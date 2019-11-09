//
//  Effect.swift
//  Redux
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine

public protocol Effect {
    associatedtype Action
    associatedtype Dependencies
    func mapToAction(dependencies: Dependencies) -> AnyPublisher<Action, Never>
}

extension Effect {
    public func eraseToAnyEffect() -> AnyEffect<Action, Dependencies> {
        AnyEffect(self)
    }
}

public struct AnyEffect<Action, Dependencies> {
    @usableFromInline
    internal let box: EffectBoxBase<Action, Dependencies>

    @inlinable
    public init<E: Effect>(_ effect: E) where Action == E.Action, Dependencies == E.Dependencies {
        box = EffectBox(base: effect)
    }
}

extension AnyEffect: Effect {
    @inlinable
    public func mapToAction(dependencies: Dependencies) -> AnyPublisher<Action, Never> {
        box.mapToAction(dependencies: dependencies)
    }
}

@usableFromInline
internal class EffectBoxBase<Action, Dependencies>: Effect {
    @inlinable
    internal init() {}

    @usableFromInline
    func mapToAction(dependencies: Dependencies) -> AnyPublisher<Action, Never> {
        abstractMethod()
    }
}

@usableFromInline
internal final class EffectBox<E: Effect>
    : EffectBoxBase<E.Action, E.Dependencies>
{
    @usableFromInline
    internal let base: E

    @inlinable
    internal init(base: E) {
        self.base = base
        super.init()
    }

    @inlinable
    override func mapToAction(dependencies: E.Dependencies) -> AnyPublisher<E.Action, Never> {
        base.mapToAction(dependencies: dependencies)
    }
}

internal func abstractMethod(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Abstract method call", file: file, line: line)
}
