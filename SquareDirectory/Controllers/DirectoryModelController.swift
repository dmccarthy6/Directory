
//  Created by Dylan  on 1/18/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

class ModelController {
    
    //MARK: - Properties
    private (set) var directoryData = [Contact]() {
        didSet {
            directoryData.sort(by: { $0.team < $1.team })
        }
    }
    var session: URLSession
    private let directory = GetDirectoryData()
    private let imageLoader = ImageLoader()
    
    
    //MARK: - Initializers
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    //MARK: - Network Functions
    func getNetowrkData(completion: @escaping (APIError?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var error: APIError?
        
        dispatchGroup.enter()
        
        fetchDirectoryNames { (results) in
            switch results {
            case .success(let employeeResults):
                if let employeeResult = employeeResults {
                    self.directoryData = employeeResult.employees!
                }
            case .failure(let apiError):
                error = apiError
                completion(apiError)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if self.directoryData.count > 0 {
                completion(nil)
            }
            else {
                completion(error)
            }
        }
    }
    
    func loadImageFor(cell: UITableViewCell, url: URL, uuid: String, completion: @escaping (APIError?) -> Void) -> String? {
        let token = imageLoader.loadImage(url, uuid: uuid) { (results) in
            do {
                let image = try results.get()
                DispatchQueue.main.async {
                    if let cell = cell as? PersonCell {
                        cell.setImage(image)
                    }
                }
            }
            catch {
                completion(.imageFailedToLoad)
            }
        }
        return token
    }

    func fetchContactFor(row: Int) -> Contact {
        return directoryData[row]
    }
    
    //MARK: - Private methods
    /*Change 'from' value in fetchDirectoryNames to .empty or .malformed to test errors */
    private func fetchDirectoryNames(completion: @escaping (Result<EmployeesResult?, APIError>) -> Void) {
        directory.fetchDirectoryNames(from: .validData) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let allEmployees):
                if let employeesArray = allEmployees {
                    completion(.success(employeesArray))
                }
            }
        }
    }
    
    
}
