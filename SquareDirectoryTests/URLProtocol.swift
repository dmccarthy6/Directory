//
//  URLProtocol.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/20/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
@testable import SquareDirectory

class URLProtocolMock: URLProtocol {
    
    static var testURLs = [URL? : Data]()
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let url = request.url {
            if let data = URLProtocolMock.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    //required but not needed.
    override func stopLoading() {}
}
