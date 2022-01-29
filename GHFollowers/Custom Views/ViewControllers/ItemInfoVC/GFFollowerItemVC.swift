//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation


protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    var delegate: GFFollowerItemVCDelegate!
    
    
    // MARK: Init
    // this initializer allow you to set the delegate object at the same time
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // This method use superclass's property
    // and action button's method
    private func configureItems () {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3") // this method is calle from GFButtonClass
    }
    
    // this method related to both Userinfo and FollowerList
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
