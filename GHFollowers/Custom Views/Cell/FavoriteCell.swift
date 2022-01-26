//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/26.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    // using static attribute to allow object to use entirely
    static let reuseId = "FollowerCell" // this variable should be Identical class name
    
    // make the components for showing the image and label on FollowerVC
    let avatarImageView = GFAvatarImageView(frame: .zero)
    var userNameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // this method get the data from follower
    // and then setting the user from data
    func set(favorite: Follower) {
        self.userNameLabel.text = favorite.login
        avatarImageView.downLoadImage(from: favorite.avatarUrl)
    }
    
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        
        accessoryType = .disclosureIndicator // this line add ">" mark in cell
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
