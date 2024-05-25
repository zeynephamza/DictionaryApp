//
//  MockHomeViewController.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 25.05.2024.
//

import Foundation
@testable import DictionaryApp
@testable import DictionaryAPI


class MockViewController: HomeViewControllerProtocol {
    var showWordDefinitionCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    
    func showWordDefinition(_ word: WordElement) {
        showWordDefinitionCalled = true
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}
