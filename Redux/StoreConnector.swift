//
//  StoreConnector.swift
//  Redux
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI

public struct StoreConnector<State, Action, Dependencies, V: View>: View {
    public typealias ConnectedStore = Store<State, Action, Dependencies>
    @EnvironmentObject var store: ConnectedStore
    let content: (State, ConnectedStore) -> V

    public var body: V {
        content(store.state, store)
    }
}
