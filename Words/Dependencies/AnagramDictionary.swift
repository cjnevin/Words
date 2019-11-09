//
//  AnagramDictionary.swift
//  Words
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import WordsCore

func hashValue(_ word: String) -> String {
    return String(word.sorted())
}

func hashValue(_ characters: [Character]) -> String {
    return String(characters.sorted())
}

struct AnagramDictionary: WordValidator {
    private let words: Words

    init?(data: Data) {
        guard let words = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Words else {
            return nil
        }
        self = AnagramDictionary(words: words)
    }

    init(words: Words) {
        self.words = words
    }

    subscript(letters: [Character]) -> Anagrams? {
        return words[hashValue(letters)]
    }

    func validate(word: String) -> Bool {
        let lowercased = word.lowercased()
        return self[hashValue(lowercased)]?.contains(lowercased) ?? false
    }
}

class AnagramBuilder {
    private var words = Words()

    func addWord(_ word: String) {
        let hash = hashValue(word)
        var existing = words[hash] ?? []
        existing.append(word)
        words[hash] = existing
    }

    func serialize() -> Data {
        return try! JSONSerialization.data(withJSONObject: words, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}
