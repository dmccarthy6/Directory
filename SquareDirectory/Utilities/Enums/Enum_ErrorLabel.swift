//
//  ErrorEnums.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/18/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

enum ErrorLabelText {
    
    case noData
    case errorFetchingData
    
    var text: String {
        switch self {
        case .noData: return "Uh Oh! Something went wrong looks like the data is empty. Please try again"
        case .errorFetchingData: return "Uh Oh! Something went wrong fetching data. Please try again"
        }
    }
    
}
