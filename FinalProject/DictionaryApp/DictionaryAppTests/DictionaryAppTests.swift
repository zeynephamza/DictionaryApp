//
//  DictionaryAppTests.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 17.05.2024.
//
import XCTest
@testable import DictionaryApp
@testable import DictionaryAPI

// Mock Classes
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

class MockInteractor: HomeInteractorProtocol {
    var presenter: (any DictionaryApp.HomeInteractorOutputProtocol)?
    
    var fetchWordDataCalled = false
    var fetchWordCalled = false
    var fetchWordCompletion: ((Result<WordElement, Error>) -> Void)?
    
    func fetchWordData(for word: String) {
        fetchWordDataCalled = true
    }
    
    func fetchWord(for word: String, completion: @escaping (Result<WordElement, Error>) -> Void) {
        fetchWordCalled = true
        fetchWordCompletion = completion
    }
}

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

class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var mockView: MockViewController!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!

    override func setUp() {
        super.setUp()
        
        //inits
        mockView = MockViewController()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        presenter = HomePresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func test_viewWillAppear_InvokesRequiredViewMethod(){
        XCTAssertFalse(mockInteractor.fetchWordCalled, "Passed")
        
        
    }
    
    func test_searchWordCallsInteractor() {
        presenter.searchWord("test")
        XCTAssertTrue(mockInteractor.fetchWordDataCalled)
    }

    func test_didFailToFetchWordDataCallsView() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error message"])
        presenter.didFailToFetchWordData(with: error)
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Error message")
    }

    func test_searchWordWithCompletionFails() {
        let completionExpectation = expectation(description: "Completion called")
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error message"])
        presenter.searchWord("test") { _ in
            XCTFail("Completion should not be called on failure")
        }
        mockInteractor.fetchWordCompletion?(.failure(error))
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Error message")
        completionExpectation.fulfill()
        waitForExpectations(timeout: 1, handler: nil)
    }
    

}
