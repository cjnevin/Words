//
//  ConnectedView.swift
//  Redux
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI

public protocol ConnectedView: View {
    associatedtype Action
    associatedtype State
    associatedtype Dependencies
    associatedtype Props
    associatedtype V: View

    func map(state: State, store: Store<State, Action, Dependencies>) -> Props
    func body(props: Props) -> V
}

public extension ConnectedView {
    func render(state: State, store: Store<State, Action, Dependencies>) -> V {
        let props = map(state: store.state, store: store)
        return body(props: props)
    }

    var body: StoreConnector<State, Action, Dependencies, V> {
        return StoreConnector(content: render)
    }
}
