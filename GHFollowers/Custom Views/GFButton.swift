//
//  GFButton.swift
//  GHFollowers
//
//  Created by kitano hajime on 2021/12/01.
//  Copyright © 2021 Sean Allen. All rights reserved.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //cutome code
        configure()
    }
    
    //implement another init method
    init(backGroundCoor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backGroundCoor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
