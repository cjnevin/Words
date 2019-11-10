//
//  Device.swift
//  Words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Combine
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

final class Device: ObservableObject {
    enum Kind {
        case mac
        case phone
        case pad
    }

    @Published var isLandscape: Bool = false

    var kind: Kind {
        #if canImport(AppKit)
        return .mac
        #else
        return UIDevice.current.userInterfaceIdiom == .pad ? .pad : .phone
        #endif
    }

    var menuFont: Font {
        switch kind {
        case .phone: return .callout
        default: return .headline
        }
    }

    var tileDimension: CGFloat {
        switch kind {
        case .phone: return 50
        case .mac: return 100
        default: return 120
        }
    }

    var edges: Edge.Set {
        switch kind {
        case .pad: return .top
        default: return .init()
        }
    }
}
