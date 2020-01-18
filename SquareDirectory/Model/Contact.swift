//
//  Contact.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    let uuid: String
    let fullName: String
    let phoneNumber: String
    let emailAddress: String
    let biography: String
    let photoSmall: URL
    let photoLarge: URL
    let team: String
    let employeeType: String
    
    
    private enum CodingKeys : String, CodingKey {
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photoSmall = "photo_url_small"
        case photoLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }
}


