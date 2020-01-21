//
//  APITests.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/19/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import XCTest
@testable import SquareDirectory

class NetworkTests: XCTestCase {
    //MARK: Properties
    var getDirectoryData: GetDirectoryData!
    let session = MockURLSession()
    
    
    
    override func setUp() {
        super.setUp()
        
        getDirectoryData = GetDirectoryData(session: session)
    }
    
    
    /* Test that the URL Session creates the request with the correct url*/
    func testWithURL() {
        let directoryURL = DirectoryURL.validData
        
        getDirectoryData.fetchDirectoryNames(from: directoryURL) { (result) in
            print(result)
        }
        XCTAssert(session.lastURL == directoryURL.urlComponents.url)
    }
    
    /* Test that the URLSession 'resume' is correctly called*/
    func testResumeWasCalled() {
        let dataTask = MockDataTask()
        session.nextDataTask = dataTask
        
        getDirectoryData.fetchDirectoryNames(from: .validData) { (result) in
            print(result)
        }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    /* */
    func testGettingData() {
        var employeeResultData: EmployeesResult?
        
        getDirectoryData.fetchDirectoryNames(from: .validData) { (result) in
            switch result {
            case .success(let employeeResult):
                employeeResultData = employeeResult
                
            case .failure(let apiError):
                print("ERROR TESTS: \(apiError)")
            }
        }
        XCTAssertNil(employeeResultData)
    }
    
    /* Test that nil error is firing correctly on empty data endpoint*/
    func testDirectoryNilDataError() {
        let nilAPIError = APIError.jsonDataMalformed
        var errorNil: APIError?
        
        getDirectoryData.fetchDirectoryNames(from: .empty) { (result) in
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
    
    //MARK: - Live Network Tests(if desired)
    /* These Unit tests hit the network, use to determine if there are any undocumented API changes. */
    
//    func testDirectoryWithValidData() {
//        let directoryLive = GetDirectoryData(session: URLSession(configuration: .default))
//        let expectation = self.expectation(description: "DirectoryValid")
//        var contactsArray: [Contact]?
//
//        directoryLive.fetchDirectoryNames(from: .validData) { (result) in
//            switch result {
//            case .success(let data):
//                if let employees = data {
//                    contactsArray = employees.employees
//
//                    expectation.fulfill()
//                }
//            case .failure(let error):
//                print("error\(error)e")
//            }
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssert(contactsArray!.count > 0, "Something's wrong, there are no employees in the directory")
//    }
    
    
    //MARK: - Teardown
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
