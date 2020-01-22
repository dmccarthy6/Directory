//
//  Enum_ImageError.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/21/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

enum ImageError: Error {
    
    case imageFailedToLoad
    case noData
    
    var localizedDescription: String {
        switch self {
        case .imageFailedToLoad:            return "Image failed to load"
        case .noData:                      return "No Image Data Received"
        }
    }
    
}
