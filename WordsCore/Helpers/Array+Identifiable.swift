//
//  Array+Identifiable.swift
//  WordsCore
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

extension Array: Identifiable where Element: Identifiable {
    public var id: String {
        return map { String($0.id.hashValue) }.joined(separator: "|")
    }
}
