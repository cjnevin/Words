//
//  ConnectedView.swift
//  Redux
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI

public protocol ConnectedView: View {
    associatedtype R: Reducer
    associatedtype Props
    associatedtype V: View

    func map(state: R.State, send: @escaping (R.E.Action) -> Void) -> Props
    func body(props: Props) -> V
}

public extension ConnectedView {
    func render(state: R.State, send: @escaping (R.E.Action) -> Void) -> V {
        let props = map(state: state, send: send)
        return body(props: props)
    }

    var body: StoreConnector<R, V> {
        return StoreConnector(content: render)
    }
}
