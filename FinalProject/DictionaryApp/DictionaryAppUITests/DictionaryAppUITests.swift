//
//  DictionaryAppUITests.swift
//  DictionaryAppUITests
//
//  Created by Zeynep Özcan on 17.05.2024.
//

import XCTest

final class DictionaryAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleSearchAndBack() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        
        app.typeText("Home")
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons.matching(identifier: \"Search\").staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["arrow.backward"].tap()
  
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTryToPlaySound() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        
        app.typeText("Car")
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons.matching(identifier: \"Search\").staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        app.buttons["person.wave.2"].tap()
        sleep(2)
        app.buttons["arrow.backward"].tap()
  
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGoToFirstSynonym() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        app.typeText("Car")
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.textViews.textViews["A passenger-carrying unit in a subway or elevated train, whether powered or not."].tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
 
    func testTypeInRandomWord() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        app.launch()
        
        app.searchFields["Search"].tap()
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.typeText("randomwordtyped")
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.alerts["This word could not be found."].scrollViews.otherElements.buttons["OK"].tap()
                
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testWordTypeButtons() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.searchFields["Search"].tap()
        app.typeText("swift")
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let nounButton = elementsQuery.buttons["Noun"]
        nounButton.tap()
        
        let adjectiveButton = elementsQuery.buttons["Adjective"]
        adjectiveButton.tap()
        
        let adverbButton = elementsQuery.buttons["Adverb"]
        adverbButton.tap()
        elementsQuery.buttons["Noun, Adjective, Adverb"].tap()
        adjectiveButton.tap()
        adjectiveButton.tap()
        adverbButton.tap()
        adverbButton.tap()
        adverbButton.tap()
        adjectiveButton.tap()
        nounButton.tap()
        elementsQuery.buttons["Adverb, Adjective, Noun"].tap()
        adjectiveButton.tap()
        
        let button = elementsQuery.buttons["✕"]
        button.tap()
        nounButton.tap()
        button.tap()
        adverbButton.tap()
        button.tap()
                    
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
