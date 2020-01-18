
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation

struct EmployeesResult: Decodable {
    
    /* Employees is an array of contacts, from JSON. Using this to access the array of contacts to display in tableview */
    let employees: [Contact]?
}
