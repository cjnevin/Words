//
//  Sequence+Intersection.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    func intersection(with original: Element, mapping: @escaping (Element) -> Int) -> [Element]? {
        let elements = sorted(by: { mapping($0) < mapping($1) })
        guard let min = elements.first.map(mapping), let max = elements.last.map(mapping), min < max else {
            return nil
        }
        var intersecting: [Element] = []
        var i = mapping(original)
        while i >= min {
            guard let touching = first(where: { mapping($0) == i }) else {
                break
            }
            intersecting.append(touching)
            i -= 1
        }
        i = mapping(original)
        while i <= max {
            guard let touching = first(where: { mapping($0) == i }) else {
                break
            }
            intersecting.append(touching)
            i += 1
        }
        intersecting = intersecting.unique
        guard intersecting.count > 1 else {
            return nil
        }
        return intersecting
    }
}
