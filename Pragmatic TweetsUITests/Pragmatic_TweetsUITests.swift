//
//  Pragmatic_TweetsUITests.swift
//  Pragmatic TweetsUITests
//
//  Created by Matthew Rieger on 11/2/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import XCTest

class Pragmatic_TweetsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSentTweet() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      
      let app = XCUIApplication()
      app.buttons["Send Tweet"].tap()
      NSThread.sleepForTimeInterval(2.0)
      XCTAssertTrue(app.navigationBars["Twitter"].buttons["Cancel"].exists)
    }
    
}
