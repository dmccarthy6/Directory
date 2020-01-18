//
//  ActivityIndicator.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

struct ActivityIndicator {
    
    //MARK: - Properties
    private static let activityIndicator = UIActivityIndicatorView()
    
    
    //MARK: - Display Activity Indicator
    static func displayActivityIndicator(with xAnchor: NSLayoutXAxisAnchor, yAnchor: NSLayoutYAxisAnchor, inView: UIView) -> UIActivityIndicatorView {
        //Add to Subview
        inView.addSubview(activityIndicator)
        
        //Set Color
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: xAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: yAnchor)
        ])
        
        return activityIndicator
    }
    
}
