//
//  Alerts.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import UIKit

enum Alerts {
    
    
    static func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        self.rootViewController().present(alertController, animated: true, completion: nil)
    }
    
    
    //Get Root View Controller
    private static func rootViewController() -> UIViewController {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), let rootVC = window.rootViewController {
            return rootVC
        }
        return UIViewController()
    }
    
}
