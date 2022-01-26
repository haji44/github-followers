//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/21.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
// This class has the setting about the image of avatar
class GFAvatarImageView: UIImageView {
    let cache = NetWorkManager.shared.cache
    // this code get the data from the asset folder
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    // initialize uiimage
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // configure the image setting
    // assing the placeholderImage to image
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }


    
    
}
