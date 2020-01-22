
//  Created by Dylan  on 1/18/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

/*
 - Perform database queries and pass data to the ViewController through completions.
 - Contain the tableView dataSource property(directoryData) that is being set in this class with the 'getDirectoryEmployees' method, sorting data here by 'team'
 */

final class ModelController: API {
    
    //MARK: - Properties
    private (set) var directoryData = [Contact]() {
        didSet {
            directoryData.sort(by: { $0.team < $1.team })
        }
    }
    var session: URLSession
    private let imageLoader = ImageLoader()
    
    
    
    //MARK: - Initializers
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    //MARK: - Network Functions
    func getDirectoryEmployees(from url: DirectoryURL, completion: @escaping (APIError?) -> Void) {
        fetchEmployeesFromNetwork(from: url) { (result) in
            switch result {
            case .failure(let apiError):
                completion(apiError)
                
            case .success(let employees):
                if let employeesArray = employees, let contacts = employeesArray.employees {
                    self.directoryData = contacts
                    completion(nil)
                }
            }
        }
    }
    
    /* Using the ImageLoader to fetch images to be displayed in the tableView. This method is called in */
    func loadImageFor(url: URL, uuid: String, completion: @escaping (UIImage?, APIError?) -> Void) -> String? {
        let token = imageLoader.loadImage(url, uuid: uuid) { (results) in
            do {
                let image = try results.get()
                completion(image, nil)
            }
            catch {
                completion(nil, .imageFailedToLoad)
            }
        }
        return token
    }
    
    /* Cancel the load image; used when cell is dequeueing. */
    func cancelImageLoad(token: String, uuid: String) {
        imageLoader.cancelLoad(for: token, uuid: uuid)
    }
    
    /* Created this method to be used in the DirectoryViewController to obtain the data for a tapped cell. */
    func fetchContactFor(indexPath: IndexPath) -> Contact {
        return directoryData[indexPath.row]
    }
    
    //MARK: - Private methods
    func fetchEmployeesFromNetwork(from url: DirectoryURL, completion: @escaping (Result<EmployeesResult?, APIError>) -> Void) {
        fetchNetworkData(with: url.urlRequest, decode: { (json) -> EmployeesResult? in
            guard let employeesArray = json as? EmployeesResult else { return nil }
            return employeesArray
        }, completionHandler: completion)
    }
    
    
}
