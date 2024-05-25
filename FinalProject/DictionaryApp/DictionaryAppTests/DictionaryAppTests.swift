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

        mockPresenter.recentSearches = ["a", "b", "c", "d"]
        
        mockPresenter.addRecentSearch("a")
        XCTAssertTrue(mockPresenter.recentSearches[0...3] == ["a", "b", "c", "d"])

        mockPresenter.addRecentSearch("g")
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == ["g", "a", "b", "c", "d"])
        
        mockPresenter.addRecentSearch("c")
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == [ "c", "g", "a", "b", "d"])

        mockPresenter.addRecentSearch("o")
        XCTAssertTrue(mockPresenter.recentSearches[0...4] == ["o", "c", "g", "a", "b"])
        
        mockPresenter.addRecentSearch("x")
        XCTAssertFalse(mockPresenter.recentSearches[0...4] == ["x","o", "c", "g", "a", "b"])
    }

}

/*
final class HistoryCellPresenter: XCTestCase{
    var presenter: HistoryCellPresenter!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults(suiteName: "TestDefaults")
        presenter = HistoryCellPresenter(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
       presenter = nil
       mockUserDefaults = nil
       super.tearDown()
   }
}
*/
