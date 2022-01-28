//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// This class is used in userinfoVC
class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // because this label always assing left side,
    // in that case we should set font size instead of text allinment
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail // generally title should be one line
        translatesAutoresizingMaskIntoConstraints = false
    }

}
