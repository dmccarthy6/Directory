//
//  URLProtocolStub.swift
//  SquareDirectoryTests
//
//  Created by Dylan  on 1/18/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

class URLProtocolStub: URLProtocol {
    
    //MARK - Properties
    static var testURL = [URL? : Data]()
    
    
    //
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url, let data = URLProtocolStub.testURL[url] {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
