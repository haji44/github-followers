//
//  GFTabBarControllerViewController.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/27.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class GFTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    //2. implemet the methods to create the searchVC
    //   before write this codd, the SearchVC class is needed
    func createSearchNC() -> UINavigationController {
        // 2-1. make the instance of SearchVC
        let searchVC = SearchVC()

        searchVC.title = "Search"
        // UItabarItem has some option
        // tabBarSystemItem can use the default icon
        // UITabBarItem(tabBarSystemItem: type of the icon, tag: place of the item in the tabbar)
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoriteListVC = FavoriteListVC()
        favoriteListVC.title = "Favorite"
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteListVC)
    }
    

    

}
