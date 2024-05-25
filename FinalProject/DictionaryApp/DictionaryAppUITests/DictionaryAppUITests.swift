//
//  DictionaryAppUITests.swift
//  DictionaryAppUITests
//
//  Created by Zeynep Özcan on 17.05.2024.
//

import XCTest

final class DictionaryAppUITests: XCTestCase {


    func testSimpleSearchAndBack() throws {
        // tests the back button after searching a valid word
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        
        app.typeText("Home")
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons.matching(identifier: \"Search\").staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["arrow.backward"].tap()
  
    }
    
    func testTryToPlaySound() throws {
        // test for sound button for a valid word search
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        
        app.typeText("Car")
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons.matching(identifier: \"Search\").staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        app.buttons["person.wave.2"].tap()
        sleep(2)
        app.buttons["arrow.backward"].tap()
  
    }
    
    func testGoToFirstSynonym() throws {
        // Go to first synonym for the word Car
        let app = XCUIApplication()
        app.launch()

        app.searchFields["Search"].tap()
        app.typeText("Car")
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.textViews.textViews["A passenger-carrying unit in a subway or elevated train, whether powered or not."].tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
 
    func testTypeInRandomWord() throws {
        // Enter a invalid word and search it. Check if error  appeared
        let app = XCUIApplication()
        
        app.launch()
        
        app.searchFields["Search"].tap()
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.typeText("randomwordtyped")
        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        app.alerts["This word could not be found."].scrollViews.otherElements.buttons["OK"].tap()
        
    }
    
    func testWordFilterTypeButtons() throws {
        // check if filter types are working for the word home
        let app = XCUIApplication()
        app.launch()
        
        app.searchFields["Search"].tap()
        app.typeText("home")

        app.buttons.containing(.staticText, identifier:"Search").element.tap()
        
        let scrollViewsQuery = app.scrollViews
        let nounButton = scrollViewsQuery.otherElements.containing(.button, identifier:"✕").children(matching: .button).matching(identifier: "Noun").element(boundBy: 0)
        nounButton.tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let verbButton = elementsQuery.buttons["Verb"]
        verbButton.tap()
        elementsQuery.buttons["Adjective"].tap()
        elementsQuery.buttons["Noun, Verb, Adjective"].tap()
        elementsQuery.buttons["Noun, Verb"].tap()
        nounButton.tap()
        verbButton.tap()
        elementsQuery.buttons["✕"].tap()
        app.buttons["arrow.backward"].tap()
 
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
