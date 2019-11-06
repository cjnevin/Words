//
//  StoreProvider.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Combine
import SwiftUI

public struct StoreProvider<State, Action, Dependencies, V: View>: View {
    public let store: Store<State, Action, Dependencies>
    public let content: () -> V

    public init(store: Store<State, Action, Dependencies>, content: @escaping () -> V) {
        self.store = store
        self.content = content
    }

    public var body: some View {
        content().environmentObject(store)
    }
}
