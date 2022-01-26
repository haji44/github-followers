//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/27.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// this class is called in the GFAlert
class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
