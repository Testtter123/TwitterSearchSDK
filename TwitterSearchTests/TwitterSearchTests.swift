//
//  TwitterSearchTests.swift
//  TwitterSearchTests
//
//  Created by Michael on 20/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import XCTest
@testable import TwitterSearch


class TwitterSearchTests: XCTestCase {
    
    struct TwitterTokens {
        static let consumerKey = "V6qVv1JMT13wY7NWtxLPjtQPM"
        static let consumerSecret = "F4V5sIyP4iwiGOkSY0DAdKKHlBa7034YxxGh2nWKHznEWdJLEU"
        static let userAccessToken = "793382406409650176-RIoO28OnGxNhy5wIb09H9xgn5i7EQfy"
        static let userAccessTokenSecret = "RKTM6psHXerPxe8rBaXAqqXvqwqzVINHglE7YlzNRXy6J"
    }

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDidSetTokens() {
        TwitterSearch.shared.setTwitterTokens(consumerKey: TwitterTokens.consumerKey, consumerSecret: TwitterTokens.consumerSecret, userAccessToken: TwitterTokens.userAccessToken, userAccessTokenSecret: TwitterTokens.userAccessTokenSecret)
        
        XCTAssertNotNil(TwitterSearch.shared.twitterAuthTokens)
        XCTAssertEqual(TwitterSearch.shared.twitterAuthTokens?.consumerKey,TwitterTokens.consumerKey)
        XCTAssertEqual(TwitterSearch.shared.twitterAuthTokens?.consumerSecret,TwitterTokens.consumerSecret)
        XCTAssertEqual(TwitterSearch.shared.twitterAuthTokens?.userAccessToken,TwitterTokens.userAccessToken)
       XCTAssertEqual(TwitterSearch.shared.twitterAuthTokens?.userAccessTokenSecret,TwitterTokens.userAccessTokenSecret)
    }
    
    func testURLBuilder() {
        let searchString = "https://api.twitter.com/1.1/search/tweets.json?q=%23blabla"
        let url = TwitterSearch.shared.urlBuilder(searchTerm: "blabla")
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString,searchString)
    }
    
    func testHeaders() {
        let fakeAuth = "fakeAuth"
        let authHeaderName = "Authorization"
        let authHeaders = TwitterSearch.shared.headers(authorization: fakeAuth)
        XCTAssertNotNil(authHeaders[authHeaderName])
        XCTAssertEqual(authHeaders[authHeaderName],fakeAuth)
        
    }
    
    func testRequestToTwitter() {
        
        //TODO: use a mock framework instead of real network connection
        
        let twitterRequest = expectation(description: "search")        

        TwitterSearch.shared.search(hashTag: "test") { [weak self] (result) in
            guard let me = self else {
                return
            }
            switch result {
            case let .success(response):
                let twittes = response.statuses
                XCTAssertNotNil(twittes)
                XCTAssertGreaterThan(twittes?.count ?? -1,0)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            twitterRequest.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
