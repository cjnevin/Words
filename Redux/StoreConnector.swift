//
//  StoreConnector.swift
//  Redux
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI

public struct StoreConnector<R: Reducer, V: View>: View {
    @EnvironmentObject var store: Store<R>
    let content: (R.State, @escaping (R.E.Action) -> Void) -> V

    
    public var body: V {
        content(store.state, store.send)
    }
}
