//
//  APIErrorEnum.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:                return "Request Failed"
        case .invalidData:                  return "Invalid Data"
        case .responseUnsuccessful:          return "Response Unsuccessful"
        case .jsonParsingFailure:            return "JSON Parsing Failure"
        case .jsonConversionFailure:         return "Failed to properly convert JSON data from server"
        }
    }
    
    
}
