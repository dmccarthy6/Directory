
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

enum DirectoryURL {
    case validData
    case malformed
    case empty
}

extension DirectoryURL: Endpoint {
    var scheme: String {
        return "https"
    }
    var host: String {
        return "s3.amazonaws.com"
    }
    var path: String {
        switch self {
        case .validData:        return "/sq-mobile-interview/employees.json"
        case .malformed:        return "/sq-mobile-interview/employees_malformed.json"
        case .empty:            return "/sq-mobile-interview/employees_empty.json"
        }
    }
    
}




