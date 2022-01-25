//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/16.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

protocol FollowerListVCDelegate: class {
    func didRequestFollower(for username: String)
}


// This class in charge of the showing the follower for user
class FollowerListVC: UIViewController {
    // Property
    enum Section { case main }
    var page = 1
    var hasMoreFollower = true  // this flag decide whether
    var userName: String!
    var follwers = [Follower]()
    var filterdFollers = [Follower]() // this object update via search bar
    var collectionView: UICollectionView!
    var isSarching = false // this flag determains
    // datasource are required to confirm Hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    // keep the code concise within this method
    // Never write the actual implementation to avoid messy looks
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: userName, page: page)
        configureDataSource()
    }
    
    // prevent from erasing the navigation item, when swipe this view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // This method is responsible for setting against the view controller.
    // So that the code keeps the code easily maintained,
    // the setting of view controller should be aside from viewDidLoad.
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        // apply the barbutton to navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = doneButton

    }
    
    // This method is responsible for initialising the collection view
    // and registering the object we want to show to the user.
    func configureCollectionView() {
        // initialize the object to add a subview
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTheCoulumnFlowLayou(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        // Because reuseId is declared as a static variable,
        // we no longer need to create the FollowerCell instance.
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    // Within this method, create the searchController
    // and then swift require this class confirm to searchResultUpdating protcol and UIsearchBar protcol
    func configureSearchController() {
        let seartchController = UISearchController()
        seartchController.searchResultsUpdater = self
        seartchController.searchBar.delegate = self // this delegate object notify the action when user interact with view
        seartchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = seartchController
    }
    
    
    // This method treat the excution as result
    // and then we handle the error based on the result enum
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetWorkManager.shared.getFollowers(for: userName, page: page) { [weak self ] result in
            // because weak keyword return optional,
            // so you should check precondition of self
            guard let self = self else { return }
            
            self.dismissLodingView()
            
            switch result {
            // when method sucess, just print the data
            case .success(let followers):
                // update follower objects and data source
                if followers.count < 100 { self.hasMoreFollower = false }
                self.follwers.append(contentsOf: followers)
                
                if self.follwers.isEmpty {
                    let mesage = "This user doesn't have any followers. 🥲"
                    
                    DispatchQueue.main.async { self.showEmptyStateView(with: mesage, in: self.view) }
                    return
                }
                self.updateData(on: followers)
                
            // when method failer, show alert
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    // This method return collectionviewCell
    func configureDataSource() {
        // collectionView: view
        // indexPath: the number of the index
        // follower: data set of the cell
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    // This method create snaphot which has same schem against data source
    // and it's called after excuting getFollowers
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    // when the user do following the other user
    // this method is called
    @objc func addButtonTapped() {
        print("Add Button tapped")
    }
}

// So that get new page
// the app need to detect scolling new section
extension FollowerListVC: UICollectionViewDelegate {
    // This method excute the pagenation
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollower else { return }
            page += 1
            getFollowers(username: userName, page: page)
        }
    }
    
    // When a user taps item, this method will call
    // and then show a modal presentation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // change the object which treat upcoming by flag
        let activeArray = isSarching ?  filterdFollers : follwers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

// This extentin need to use the updateSearchResult
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSarching = true
        filterdFollers = follwers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filterdFollers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSarching = false
        updateData(on: follwers)
    }
        
}

//
extension FollowerListVC: FollowerListVCDelegate {
    
    // this method is responsible for researching the result of user which was tapped in UserInfo
    func didRequestFollower(for username: String) {
        // set new data
        self.userName = username
        title = userName
        // reset state
        page = 1
        follwers.removeAll()
        filterdFollers.removeAll()
        collectionView.setContentOffset(.zero, animated: true) // this line code does reset view position
        // get another followers
        getFollowers(username: username, page: page)
    }
    
}
