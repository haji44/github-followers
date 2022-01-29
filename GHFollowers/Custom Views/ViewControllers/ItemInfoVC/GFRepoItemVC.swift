//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// delegate protocol should be written in sender class
// and the name ideally same
protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

// This class is subcalass of GFITemInfoVC
// and cutomised for showing repo's info
class GFRepoItemVC: GFItemInfoVC {
    
    var delegate: GFRepoItemVCDelegate!

    // this initializer allow you to set the delegate object at the same time
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // This method use superclass's property
    // and action button's method
    private func configureItems () {
        itemInfoViewOne.set(itemInfoType: .repo, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person.3") // this method is calle from GFButtonClass
    }
    

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
