//
//  MockDataTask.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/19/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
@testable import SquareDirectory

class MockDataTask: URLSessionDataTask {
    private (set) var resumeWasCalled = false

    
    
    override func resume() {
        resumeWasCalled = true
    }
    
}

