
//  Created by Dylan  on 1/19/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import XCTest
@testable import SquareDirectory

class NetworkTests: XCTestCase {
    //MARK: Properties
    let session = MockURLSession()
    var modelController: ModelController?
    
    
    override func setUp() {
        super.setUp()
        
        //Passing 'mock' URLSession created in Test Suite to test the modelController networking functions. I can use 'modelController' safely here now as it's not using the real URLSession.
        modelController = ModelController(session: session)
    }
    
    
    /* Test that the URL Session creates the request with the correct url. */
    func testWithURL() {
        let directoryURL = DirectoryURL.validData
        
        modelController?.getDirectoryEmployees(from: directoryURL, completion: { (result) in
        })
        XCTAssert(session.lastURL == directoryURL.urlComponents.url)
    }
    
    /* Test that the URLSession 'resume' is correctly called as expected. */
    func testResumeWasCalled() {
        let dataTask = MockDataTask()
        session.nextDataTask = dataTask
        
        modelController?.getDirectoryEmployees(from: .validData, completion: { (error) in
        })
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    /* Testing that the correct error is passed if there is empty data. */
    func testDirectoryNilDataError() {
        let nilAPIError = APIError.jsonDataMalformed
        var errorNil: APIError?
        
        modelController?.getDirectoryEmployees(from: .empty, completion: { (error) in
            if let error = error {
                errorNil = error
            }
        })
        XCTAssertNotEqual(nilAPIError, errorNil)
    }
    
  
    
    
    
    //MARK: - Live Network Tests(if desired)
    /* These Unit tests hit the network, use to determine if there are any undocumented API changes. Commenting this out as I don't want the tests continually hitting the network. */
    
//    func testDirectoryWithValidData() {
//        let directoryLive = ModelController(session: URLSession(configuration: .default))
//        let expectation = self.expectation(description: "DirectoryValid")
//        var contactsArray: [Contact]?
//
//        directoryLive.fetchEmployeesFromNetwork(from: .validData) { (result) in
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
    }
    
}
