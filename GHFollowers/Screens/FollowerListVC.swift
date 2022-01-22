//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/16.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// This class in charge of the showing the follower for user
class FollowerListVC: UIViewController {
    // Property
    enum Section {
        case main
    }
    var userName: String!
    var follower = [Follower]()
    var collectionView: UICollectionView!
    // datasource are required to confirm Hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    // keep the code concise within this method
    // Never write the actual implementation to avoid messy looks
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
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
    }
    
    // This method is responsible for initialising the collection view
    // and registering the object we want to show to the user.
    func configureCollectionView() {
        // initialize the object to add a subview
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTheCoulumnFlowLayou())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        // Because reuseId is declared as a static variable,
        // we no longer need to create the FollowerCell instance.
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    // This method is responsible for the layout of UICollectionView,
    // then specifing the number of the coulmn
    func createTheCoulumnFlowLayou() -> UICollectionViewFlowLayout {
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
    
    
    // This method treat the excution as result
    // and then we handle the error based on the result enum
    func getFollowers() {
        NetWorkManager.shared.getFollowers(for: userName, page: 1) { result in
            // declare the switch statement
            switch result {
            // when method sucess, just print the data
            case .success(let followers):
                // update follower objects and data source
                self.follower = followers
                self.updateData()
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
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(follower)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}
