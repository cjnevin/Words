//
//  Array+Chunked.swift
//  WordsCore
//
//  Created by Chris on 25/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

extension Array {
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
