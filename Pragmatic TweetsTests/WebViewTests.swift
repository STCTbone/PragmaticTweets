//
//  WebViewTests.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/2/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import XCTest
@testable import Pragmatic_Tweets

class WebViewTests: XCTestCase, UIWebViewDelegate {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
  var loadedWebViewExpectation : XCTestExpectation?
  
  func testAutomaticWebLoad() {
    guard let viewController = UIApplication.sharedApplication().windows[0].rootViewController as? ViewController else {
      XCTFail("couldn't get root view controller")
      return
    }
    viewController.twitterWebView.delegate = self
    loadedWebViewExpectation = expectationWithDescription("web view auto-load test")
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    XCTFail("web view load failed")
    loadedWebViewExpectation?.fulfill()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    if let webViewContents = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.textContent") where webViewContents != "" {
      loadedWebViewExpectation?.fulfill()
    }
  }
}
