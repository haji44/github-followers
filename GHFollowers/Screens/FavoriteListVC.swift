//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2021/11/28.
//  Copyright © 2021 Sean Allen. All rights reserved.
//

import UIKit

class FavoriteListVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        
        PersistanceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                break
            case .failure(let error):
                break
            }
        }
        
        
    }
    

}
