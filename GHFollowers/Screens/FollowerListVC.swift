//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/16.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit




// This class in charge of the showing the follower for user
class FollowerListVC: GFDataLoadingVC {
    // Property
    enum Section { case main }
    var page = 1
    var hasMoreFollower = true  // this flag decide whether
    var userName: String!
    var follwers = [Follower]()
    var filterdFollers = [Follower]() // this object update via search bar
    var collectionView: UICollectionView!
    var isSarching = false // this flag determains
    var isLoadingMoreFollowers = false // slow network causes the race condition so this flag reflecting loading conditions
    // datasource are required to confirm Hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    // when absent the username, app will crush
    // so we should make sure the user setting in this class
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTheCoulumnFlowLayout(in: view))
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
        seartchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = seartchController
    }
    
    
    // This method treat the excution as result
    // and then we handle the error based on the result enum
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetWorkManager.shared.getFollowers(for: userName, page: page) { [weak self ] result in
            // because weak keyword return optional,
            // so you should check precondition of self
            guard let self = self else { return }
            
            self.dismissLodingView()
            
            switch result {
            // when method sucess, just print the data
            case .success(let followers):
                self.updateUI(with: followers)
                
            // when method failer, show alert
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.isLoadingMoreFollowers = false
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
    
    func updateUI(with followers: [Follower]) {
        // update follower objects and data source
        if followers.count < 99 { self.hasMoreFollower = false }
        self.follwers.append(contentsOf: followers)
        
        if self.follwers.isEmpty {
            let mesage = "This user doesn't have any followers. 🥲"
            
            DispatchQueue.main.async { self.showEmptyStateView(with: mesage, in: self.view) }
            return
        }
        self.updateData(on: followers)
    }
    
    
    // when the user do following the other user
    // this method is called
    @objc func addButtonTapped() {
        showLoadingView()
        
        // within this closure, we use self
        // capture list is requred
        NetWorkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dismissLodingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistanceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                // when error doesn't exist
                self.pressntGFAlerOnMainThread(title: "Sucess", message: "You have sucessfully favorited this user 🎉", buttonTitle: "OK")
                return
            }
            
            // when error exist
            self.pressntGFAlerOnMainThread(title: "Some this went wrong", message: error.rawValue, buttonTitle: "OK")
        }
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
            // make sure if the user want to more loadingfollwers
            guard hasMoreFollower, !isLoadingMoreFollowers else { return }
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
extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // when a user get rid of the searchBar text
        // then we remove the filltering data and update data of follower
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filterdFollers.removeAll()
            updateData(on: follwers)
            isSarching = false
            return
        }
        isSarching = true
        filterdFollers = follwers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filterdFollers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSarching = false
        updateData(on: follwers)
    }
        
}

// MARK: UserInfoVCDelegate
extension FollowerListVC: UserInfoVCDelegate {
    
    // this method is responsible for researching the result of user which was tapped in UserInfo
    func didRequestFollower(for username: String) {
        // set new data
        self.userName = username
        title = userName
        // reset state
        page = 1
        follwers.removeAll()
        filterdFollers.removeAll()
        //  -item   : The value of the item element of the index path.
        //  -section: The value of the section element of the index path.
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true) // this line of code reset the view positon
        // get another followers
        getFollowers(username: username, page: page)
    }
    
}
