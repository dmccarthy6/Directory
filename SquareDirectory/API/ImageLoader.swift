
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit


class ImageLoader: API {
    
    //MARK: - Properties
    var session: URLSession
    private var cache = NSCache<NSString, UIImage>()
    private var runningRequests = [String : URLSessionDataTask]()
    
    
    //MARK: - Initializer
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    //MARK: Load Images Async
    func loadImage(_ url: URL, uuid: String, completion: @escaping (Result<UIImage, APIError>) -> Void) -> String? {
        let urlString = String(describing: url) as NSString
        
        if let cachedImage = cache.object(forKey: urlString) {
            print("RETURNING CACHED IMAGE")
            completion(.success(cachedImage))
            return nil
        }

        let imageTask = session.dataTask(with: url) { (data, httpResponse, error) in
            //WHEN DATA TASK COMPLETED IT SHOULD BE REMOVED FROM THE RUNNING REQUESTS DICTIONARY - DEFER TO REMOVE BEFORE RUNNING SCOPE OF COMPLETION HANDLER
            defer { self.runningRequests.removeValue(forKey: uuid) }
           
            //WHEN DATA TASK COMPLETES WE EXTRACT AN IMAGE FROM THE RESULT OF THE DATA TASK
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: urlString)
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                //No Image, No Error -- handle this
                completion(.failure(APIError.handleNoData))
                return
            }
 
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(APIError.imageFailedToLoad))
                return
            }
        }
        imageTask.resume()
        
        //Add the
        runningRequests[uuid] = imageTask
        return uuid
    }
    
    func cancelLoad(for urlString: String, uuid: String) {
        runningRequests[urlString]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
