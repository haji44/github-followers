//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// This class is subcalass of GFITemInfoVC
// and cutomised for showing repo's info
class GFRepoItemVC: GFItemInfoVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // This method use superclass's property
    // and action button's method
    private func configureItems () {
        itemInfoViewOne.set(itemInfoType: .repo, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backGroundColor: .systemPurple, title: "GitHub Profile") // this method is calle from GFButtonClass
    }
    

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
