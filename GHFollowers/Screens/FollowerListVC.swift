//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/16.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// This class in charge of the showing the follower
class FollowerListVC: UIViewController {
    //
    var userName: String!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // This treat the excution as result
        // and then we handle the error based on the result enum
        NetWorkManager.shared.getFollowers(for: userName, page: 1) { result in
            // declare the switch statement
            switch result {
            // when method sucess, just print the data
            case .success(let followers):
                print(followers)
                return
            // when method failer, show alert
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
                return
            }
        }
    }
    // prevent from erasing, when swipe this view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
