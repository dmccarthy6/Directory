
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

/* This class is used to load images to the TableView efficiently while taking dequeueing into account.
 - 'runningRequests' used to keep trac of URLSession tasks that are running when fetching image(s). Adding these tasks to runningRequests(dictionary) to keep track of them so I can cancel the task if the cell is out of view and the cell needs to reload data. This will enable the cell to load new images immediately.
 - Caching images so I don't hit the network more often than needed to increase performance and not expend users data unnecessarily.
 - Providing a function to cancel loading the image if the user is scrolling through the tableView and cells are being dequeued.
 */

final class ImageLoader: API {
    
    //MARK: - Properties
    var session: URLSession
    private var cache = NSCache<NSString, UIImage>()
    private var runningRequests = [String : URLSessionDataTask]()
    
    
    //MARK: - Initializer
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    
    //MARK: Load Images Async
    func loadImage(_ url: URL, uuid: String, completion: @escaping (Result<UIImage, ImageError>) -> Void) -> String? {
        let urlString = String(describing: url) as NSString
        
        /* I'm checking first to see if the image for the url passed in is already in Cache. If so, using that cached image and returning out of the 'loadImage' function without hitting the network. */
        if let cachedImage = cache.object(forKey: urlString) {
            print("RETURNING CACHED IMAGE")
            completion(.success(cachedImage))
            return nil
        }
        
        let imageTask = session.dataTask(with: url) { (data, httpResponse, error) in
            /* Using a defer statment to remove the completed dataTask from the running requests. Once the dataTask completes, I don't need to keep it around in runningRequests. The defer statenent will fire once the successful completion is called below and the image is passed in. */
            
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            /* Cache the image, since I've already checked that the image isn't in the cache; Then pass the image to the completion handler*/
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: urlString)
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                /* No Image, No Error, something went wrong. Passing Image Error to completion to be handled appropriately. I'm setting the image in 'PersonCell' to default to a SystemImage of a person. If I wasn't doing that I would use this 'noData' ImageError to set the appropriate image on the ImageView when I'm receiving this particular error. */
                
                completion(.failure(ImageError.noData))
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(ImageError.imageFailedToLoad))
                return
            }
        }
        imageTask.resume()
        
        /* Store the dataTask in the runningRequests dictionary with the uuid provided by the server(this is passed in as a paramater in the 'loadImage(url: uuid: completion:)' function. This function returns the uuid as a string and is used in DirectoryViewController's viewDidLoad to cancel the image if/when the cell is being reloaded (when cancelLoad(urlString: uuid:) is called. */
        
        runningRequests[uuid] = imageTask
        return uuid
    }
    
    func cancelLoad(for urlString: String, uuid: String) {
        runningRequests[urlString]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
