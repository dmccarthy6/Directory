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
    var fetchImages: FetchImages!
    
    
    override func setUp() {
        directory = GetDirectoryData(session: URLSession(configuration: .default))
        fetchImages = FetchImages()
    }

    

    //MARK: - Testing API Data Calls
    func testDirectoryWithValidData() {
        let expectation = self.expectation(description: "DirectoryValid")
        var contactsArray: [Contact]?
        
        directory.fetchDirectoryNames(from: .validData) { (result) in
            switch result {
            case .success(let data):
                if let employees = data {
                    contactsArray = employees.employees
                    
                    expectation.fulfill()
                }
            case .failure(let error):
                print("error\(error)e")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(contactsArray!.count > 0, "Something's wrong, there are no employees in the directory")
    }
    
    //Testing nil data
    func testDirectoryWithNilData() {
        let nilAPIError = APIError.invalidData
        var errorNil: APIError?
        
        directory.fetchDirectoryNames(from: .empty) { (result) in
            switch result {
            case .success(let data):
                if let _ = data {
                }
            case .failure(let error):
                errorNil = error
            }
        }
        XCTAssertNotEqual(nilAPIError, errorNil)
    }
    
    //MARK: - Testing API Image Calls
    func testImageAPI() {
        let imageURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")
        var image: UIImage?
        let expectation = self.expectation(description: "Image")
        
        fetchImages.getImage(from: imageURL!) { (result) in
            switch result {
            case .success(let downloadedImage):
                image = downloadedImage
                expectation.fulfill()
            case .failure(let apiError):
                print(apiError)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotEqual(image, nil)
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
        
        let givenURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    
    func testEmptyDataEndpoint() {
        let request = DirectoryURL.empty
        let urlRequest = request.urlRequest
        
        let givenURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    func testMalformedEndpoint() {
        let request = DirectoryURL.malformed
        let urlRequest = request.urlRequest
        
        let givenURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")
        let url = urlRequest.url
        
        XCTAssertEqual(givenURL, url!)
    }
    
    
    //MARK: - Teardown
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
