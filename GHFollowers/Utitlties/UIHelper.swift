//
//  UIHelper.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/22.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// prevent from initializing empty UIhelper,
// we should use enum
enum UIHelper {
    // This method is responsible for the layout of UICollectionView,
    // then specifing the number of the coulmn
    static func createTheCoulumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        // calculating every item width
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        // flowlayout consists of sectionInset and itemSize
        let flowLayout = UICollectionViewFlowLayout()
        // sectionInset represents space for item to item
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
}

