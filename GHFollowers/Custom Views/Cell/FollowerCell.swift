//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/21.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
// This class responsible for cell for using in uicollectionView
class FollowerCell: UICollectionViewCell {
    // using static attribute to allow object to use entirely
    static let reuseId = "FollowerCell" // this variable should be Identical class name
    
    // make the components for showing the image and label on FollowerVC
    let avatarImageView = GFAvatarImageView(frame: .zero)
    var userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // this method get the data from follower
    // and then setting the user from data
    func set(follower: Follower) {
        userNameLabel.text = follower.login
        NetWorkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.avatarImageView.image = image }
        }
    }
    
    // cofigure the cell in order to decide the way how to show the text and image
    private func configure() {
        // for now, the app need to show two components
        addSubViews(avatarImageView, userNameLabel)
        
        // declare the padding based on solid principle
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
