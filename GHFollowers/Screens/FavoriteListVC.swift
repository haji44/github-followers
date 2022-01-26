//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2021/11/28.
//  Copyright © 2021 Sean Allen. All rights reserved.
//

import UIKit

// this view controller consits of ui table view controller
class FavoriteListVC: GFDataLoadingVC {

    let tableView = UITableView()
    var favorites: [Follower] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureViewController()
        configureTableView()
    }
    
    // in order to excute update upon the user access
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // within this class,we should declare delegate and datasource
    // actual excution should be out side
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    // get the data from user defaults
    // when retrieve thedata sucess, favorites array update
    func getFavorites() {
        PersistanceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favoritess?\nAdd one on the follower screen", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}


extension FavoriteListVC: UITableViewDelegate, UITableViewDataSource {
    // this method is used to detect the number of elements of table view cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    // configure the cell data and specify new favorites
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    // upon tapped cell this method will be excuted
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    // this method is used to remove cell when swipping
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row) // this line determine the item to remove
        tableView.deleteRows(at: [indexPath], with: .left) // this line decide the way to remove animation
        
        // make sure to be identical from userdefaults and favorites
        PersistanceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.pressntGFAlerOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
            
            
            
        }
    }
}
