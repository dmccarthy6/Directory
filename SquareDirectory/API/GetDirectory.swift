
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

struct GetDirectory: API {
    //MARK: - Properties
    var session: URLSession
    private let cache = Cache<String, UIImage>()
    
    
    
    //MARK: - Initializer
    //initializing with default URLSession configuration
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    
    //MARK: - Fetch Directory
    /* Call this to perform the network request fetching names from the API endpoint*/
    func fetchDirectoryNames(from directory: DirectoryURL, completion: @escaping (Result<EmployeesResult?, APIError>) -> Void) {
        fetchData(with: directory.urlRequest, decode: { (json) -> EmployeesResult? in
            guard let contactsResult = json as? EmployeesResult else { return nil }
            return contactsResult
        }, completionHandler: completion)
    }
    
    
//    //MARK: - Fetch Images from URL or Cache
//    func getImage(from url: URL, completionHandler completion: @escaping (Result<UIImage, APIError>) -> Void) {
//        let urlKey = String(describing: url)
//        
//        //Check cache for image, if it exists in cache, use it.
//        if let cachedImage = cache[urlKey] {
//            print("CACHED")
//            return completion(.success(cachedImage))
//        }
//        
//        //Image is not cached, fetch from url
//        getImageData(from: url) { (result) in
//            switch result {
//            case .success(let data):
//                print("NOT CACHED")
//                self.cacheImage(urlKey: urlKey, imageData: data!)
//                self.asyncImageFrom(data: data!, completion)
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    //MARK: - Helpers
//    private func cacheImage(urlKey: String, imageData: Data) {
//        if let image = UIImage(data: imageData) {
//            self.cache.insert(image, forKey: urlKey)
//        }
//    }
    
}//
