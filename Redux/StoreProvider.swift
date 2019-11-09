//
//  StoreProvider.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Combine
import SwiftUI

public struct StoreProvider<R: Reducer, V: View>: View {
    public let store: Store<R>
    public let content: () -> V

    public init(store: Store<R>, content: @escaping () -> V) {
        self.store = store
        self.content = content
    }

    public var body: some View {
        content().environmentObject(store)
    }
}
