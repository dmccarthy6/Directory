//
//  SquareDirectoryTests.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import XCTest
@testable import SquareDirectory

class SquareDirectoryTests: XCTestCase {
    var directory: GetDirectoryData!
    let session = MockURLSession()
    
    
    
    override func setUp() {
        directory = GetDirectoryData(session: session)
    }

    
    //MARK: - Testing URL
    func testURLScheme() {
        let url = DirectoryURL.validData
        let isHttps = url.scheme == "https"
        XCTAssertTrue(isHttps)
    }
    
    func testURLHostForDirectory() {
        let url = DirectoryURL.empty
        let isHostCorrect = url.host == "s3.amazonaws.com"
        XCTAssertTrue(isHostCorrect)
    }
    
    
    //MARK: - Test Endpoints
    func testContainsDataEndpoint() {
        let request = DirectoryURL.validData
        let urlRequest = request.urlRequest
        let givenURL = request.urlComponents.url!
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    
    func testEmptyDataEndpoint() {
        let request = DirectoryURL.empty
        let urlRequest = request.urlRequest
        let givenURL = request.urlComponents.url!
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    func testMalformedEndpoint() {
        let request = DirectoryURL.malformed
        let urlRequest = request.urlRequest
        let givenURL = request.urlComponents.url!
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    
    
    //MARK: - Teardown
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
