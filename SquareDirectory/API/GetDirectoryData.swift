
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

struct GetDirectoryData: API {
    //MARK: - Properties
    var session: URLSession
    
    
    
    //MARK: - Initializer
    //initializing with default URLSession configuration
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    
    //MARK: - Fetch Directory
    /* Call this to perform the network request fetching names from the API endpoint*/
    func fetchDirectoryNames(from directory: DirectoryURL, completion: @escaping (Result<EmployeesResult?, APIError>) -> Void) {
        fetchNetworkData(with: directory.urlRequest, decode: { (json) -> EmployeesResult? in
            guard let contactsResult = json as? EmployeesResult else { return nil }
            return contactsResult
        }, completionHandler: completion)
    }
    
}//
