//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // This method use superclass's property
    // and action button's method
    private func configureItems () {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backGroundColor: .systemGreen, title: "Get Followers") // this method is calle from GFButtonClass
    }
    
    // this method related to both Userinfo and FollowerList
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
