
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case httpRequestFailed
    case httpResponseUnsuccessful
    case jsonConversionFailure
    case jsonDataMalformed
    case jsonParsingFailure
    case imageFailedToLoad
    case handleNoData
    
    
    var localizedDescription: String {
        switch self {
        //HTTP Errors
        case .httpRequestFailed:                return "No response from server. Check internet connection."
        case .httpResponseUnsuccessful:         return "Response Unsuccessful"
            
        //JSON Errors
        case .jsonDataMalformed:             return "JSON data is invalid."
        case .jsonParsingFailure:            return "JSON Parsing Failure"
        case .jsonConversionFailure:         return "Failed to properly convert JSON data from server"
        
        //
        case .imageFailedToLoad:            return "Image failed to load"
        case .handleNoData:                 return "No Data"
        }
    }
    
    
}
