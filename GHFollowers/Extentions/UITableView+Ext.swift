//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/29.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation
import UIKit


extension UITableView {
    // make sure to reload data in main thread
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    // this methods used to remove excess cell in table view
    func removeExcessCelss() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
