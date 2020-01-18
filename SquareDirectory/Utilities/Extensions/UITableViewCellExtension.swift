//
//  UITableViewCellExtension.swift
//  SquareDirectory
//
//  Created by Dylan  on 1/16/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    //Register the TableView Cell
    func registerTableViewCell<T: UITableViewCell>(cellClass: T.Type) {
        register(T.self, forCellReuseIdentifier: T.cellReuseIdentifier)
    }
    
    
    //Dequeue The Cell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = T.cellReuseIdentifier
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
            else {
                assertionFailure("Unable to dequeue Cell for \(identifier)")
                return T()
        }
        return cell
    }
    
    
}
