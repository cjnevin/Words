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

typealias ValidatableWords = [String: [String]]

struct AnagramDictionary: WordValidator {
    private let words: ValidatableWords

    init?(data: Data) {
        guard let words = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? ValidatableWords else {
            return nil
        }
        self = AnagramDictionary(words: words)
    }

    init(words: ValidatableWords) {
        self.words = words
    }

    subscript(letters: [Character]) -> [String]? {
        return words[hashValue(letters)]
    }

    func validate(word: String) -> Bool {
        let lowercased = word.lowercased()
        return self[hashValue(lowercased)]?.contains(lowercased) ?? false
    }
}

class AnagramBuilder {
    private var words = ValidatableWords()

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
