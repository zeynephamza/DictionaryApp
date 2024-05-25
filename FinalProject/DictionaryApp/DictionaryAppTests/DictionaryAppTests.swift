//
//  DictionaryAppTests.swift
//  DictionaryAppTests
//
//  Created by Zeynep Özcan on 17.05.2024.
//
import XCTest
@testable import DictionaryApp
@testable import DictionaryAPI


// Home Presenter Tests
final class DictionaryAppTests: XCTestCase {
    
    //All variables are forced!
    var presenter: HomePresenter!
    var mockView: MockViewController!
    var mockInteractor: MockHomeInteractor!
    var mockRouter: MockRouter!
    var mockPresenter: MockHistoryTableCell!
    

    override func setUp() {
        super.setUp()
        
        //initialization
        mockView = MockViewController()
        mockInteractor = MockHomeInteractor()
        mockRouter = MockRouter()
        presenter = HomePresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        mockPresenter = MockHistoryTableCell()
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        mockPresenter = nil
        
        super.tearDown()
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
    
    func test_fetchData(){
        // test fetchword which makes an api request, checks if the api result is expected word
        XCTAssertFalse(mockInteractor.fetchWordDataCalled)
        
        mockInteractor?.fetchWord(for: mockInteractor.myWordName) { [self] result in
            switch result {
            case .success(let wordElement):
                XCTAssertEqual(wordElement.word, mockInteractor.myWordName)
                XCTAssertTrue(mockInteractor.fetchWordDataCalled)
                
            case .failure(_ ):
                XCTAssertEqual(self.mockInteractor.testErrorMessage, "My Test Succesfully Failed")
            }
        }
       
        
    }
    
    func test_addRecentSearch(){
        // Tests if recent search function works as intended,
        mockPresenter.recentSearches = ["a", "b", "c", "d"] //initial recentsearch strings
        
        mockPresenter.addRecentSearch("a") // adding a shouldnt change anything
        XCTAssertTrue(mockPresenter.recentSearches[0...3] == ["a", "b", "c", "d"])

        mockPresenter.addRecentSearch("g") // adding g should move everything one index down and add g to to top
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == ["g", "a", "b", "c", "d"])
        
        mockPresenter.addRecentSearch("c") // adding c should move c to the first place since it already exists
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == [ "c", "g", "a", "b", "d"])

        mockPresenter.addRecentSearch("o") // adding o should remove d and add o to the top
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == ["o", "c", "g", "a", "b"])
        
        mockPresenter.addRecentSearch("x") // adding x shouldnt make the list longer since it is already 5 elements
        XCTAssertFalse(mockPresenter.recentSearches.count == ["x","o", "c", "g", "a", "b"].count)
    }

}
