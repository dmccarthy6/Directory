//
//  CacheImageView.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

//TO-DO: Remove This Class? Not needed now, cache handled in the networking layer



//final class CacheImageView: UIImageView {
//    //MARK: - Properties
//    var imageURL: URL?
//    let cache = ImageCache()
//    
//    convenience init(cache: Cache<String, UIImage>) {
//        self.cache = cache
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
//    //Obtain cached image from url passed in. Set imageView image as the cached image.
//    func loadCachedImageFrom(url: URL) {
//        let indicator = ActivityIndicator.displayActivityIndicator(with: centerXAnchor, yAnchor: centerYAnchor, inView: self)
//        
//        let urlNSString = NSString(string: url.absoluteString)
//        indicator.startAnimating()
//        let image = cache.getCachedImageFrom(urlString: urlNSString)
//        indicator.stopAnimating()
//        self.image = image
//    }
//    
//    
//}
