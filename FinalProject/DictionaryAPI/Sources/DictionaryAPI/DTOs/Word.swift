//
//  Word.swift
//
//
//  Created by Zeynep Özcan on 18.05.2024.
//

import Foundation

//MARK: - Define
public let MAX_NUM = 5  //synonym number

public typealias Word = [WordElement]

// MARK: - WordElement
public struct WordElement: Decodable {
    public let word, phonetic: String?
    public let phonetics: [Phonetic]?
    public let meanings: [Meaning]?
    public var synonyms_api: [String]?
}

// MARK: - Meaning
public struct Meaning: Decodable {
    public let partOfSpeech: String?
    public let definitions: [Definition]?
}

// MARK: - Definition
public struct Definition: Decodable {
    public let definition: String?
    public let example: String?
}

// MARK: - Phonetic
public struct Phonetic: Decodable {
    public let audio: String?
}


