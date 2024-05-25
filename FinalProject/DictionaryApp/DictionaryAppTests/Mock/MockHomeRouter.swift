//
//  MockHomeRouter.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 25.05.2024.
//

import Foundation
@testable import DictionaryApp
@testable import DictionaryAPI

class MockRouter: HomeRouterProtocol {
    var navigateToDetailCalled = false
    var word: String?
    var wordElement: WordElement?
    
    func navigateToDetail(from view: HomeViewControllerProtocol, with word: String, wordElement: WordElement) {
        navigateToDetailCalled = true
        self.word = word
        self.wordElement = wordElement
    }
}
