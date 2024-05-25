//
//  MockHomePresenter.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 25.05.2024.
//

import Foundation
@testable import DictionaryApp
@testable import DictionaryAPI

class MockHomePresenter: HomePresenterProtocol {
    var view: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?

    var searchWordCalled = false
    var searchWordWithCompletionCalled = false
    var navigateToDetailCalled = false
    var searchedWord: String?
    var searchedWordElement: WordElement?

    func searchWord(_ word: String) {
        searchWordCalled = true
        searchedWord = word
    }

    func searchWord(_ word: String, completion: @escaping (WordElement) -> Void) {
        searchWordWithCompletionCalled = true
        searchedWord = word
    }

    func navigateToDetail(with word: String, wordElement: WordElement) {
        navigateToDetailCalled = true
        searchedWord = word
        searchedWordElement = wordElement
    }
}
