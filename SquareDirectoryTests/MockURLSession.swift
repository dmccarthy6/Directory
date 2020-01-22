//
//  MockURLSession.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/19/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
@testable import SquareDirectory

class MockURLSession: URLSession, API {
    var session = URLSession(configuration: .ephemeral)//THIS IS NOT USED
    var nextDataTask = MockDataTask()
    var nextData: Data?
    var nextError: Error?
    var contact: EmployeesResult?
    private (set) var lastURL: URL?
    func resume() {}

    
    func successHTTPUrlResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastURL = request.url
        completionHandler(nextData, successHTTPUrlResponse(request: request), nextError)
        return nextDataTask
    }
    
    
}

