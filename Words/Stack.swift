//
//  Stack.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import SwiftUI

struct Stack<Content> : View where Content : View {
    @EnvironmentObject var device: Device
    private let vStack: VStack<Content>
    private let hStack: HStack<Content>
    private let verticalIfPortrait: Bool

    @inlinable init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        verticalIfPortrait: Bool = true,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content) {
        self.hStack = HStack(alignment: verticalAlignment, spacing: spacing, content: content)
        self.vStack = VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
        self.verticalIfPortrait = verticalIfPortrait
    }

    var isVertical: Bool {
        device.isLandscape ? !verticalIfPortrait : verticalIfPortrait
    }

    var body: some View {
        isVertical
            ? AnyView(vStack)
            : AnyView(hStack)
    }
}
