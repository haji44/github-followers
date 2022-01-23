//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/23.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // apply the barbutton to navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        print()
    }
    

    @objc func dismissVC() {
        dismiss(animated: true )
    }
}
