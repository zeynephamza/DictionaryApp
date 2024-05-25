//
//  MockHomeInteractor.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 25.05.2024.
//

import Foundation
@testable import DictionaryApp
@testable import DictionaryAPI

class MockHomeInteractor: HomeInteractorProtocol {
    var presenter: (any DictionaryApp.HomeInteractorOutputProtocol)?
    var testErrorMessage = "My Test Succesfully Failed"
    var isInvokedFetchWord = false
    var myWordName = "home"
    
    var fetchWordDataCalled = false
    
    var isFetchWordCalled = false
    var fetchWordCompletion: ((Result<WordElement, Error>) -> Void)?
    
    func fetchWordData(for word: String) {
        fetchWordDataCalled = true
    }
    
    func fetchWord(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        isFetchWordCalled = true
        fetchWordCompletion = completion
    }
}
