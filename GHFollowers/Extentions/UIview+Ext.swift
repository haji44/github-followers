//
//  UIview+Ext.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/28.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // this method allow the devlopper to use flexibily insert view
    func addSubViews(_ views: UIView...) {
        for view in views { addSubview(view)}
    }
    
}
