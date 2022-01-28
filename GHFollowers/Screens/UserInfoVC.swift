//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/23.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
import SafariServices


protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollower(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    let scrollView          = UIScrollView()
    let contentView           = UIView() // scroll view need conteview, and it's show the actual components
    
    let headerView          = UIView() // this view will be consist of three child view
    let itemViewOne         = UIView() // this view will be assinged GFUserItemVC
    let itemViewTwo         = UIView() // this view will be assinged GFFollowerItemVC
    let dataLabel           = GFBodyLable(textAlignment: .center)
    var itemViews: [UIView] = []

    
    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()        
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        // apply the barbutton to navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // this is responsible for setting scroll view
    // make sure contenview's height and width
    func configureScrollView() {
        view.addSubViews(scrollView)
        scrollView.addSubViews(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        // contentView need to know height and width
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 620)
        ])
    }
    
    func getUserInfo() {
        NetWorkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    // this is responsible for initializeing ui components and delegate
    func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC:  GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dataLabel.text = "GitHub Since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    // This method modify the ui setting of headerview which will be assinged new child view
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dataLabel]

        // contentView is super view, so you need to set configuration based on contentView
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dataLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dataLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // This method is responsible for building the view boundary,
    // childVC mighit be changed so you should handle thme as variable
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true )
    }
}


// MARK: GFFollowerItemInfoVCDelegate
extension UserInfoVC: GFFollowerItemVCDelegate {
    // this will be called in FollowerItemVC,
    // secondary calling this method
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0  else {
            pressntGFAlerOnMainThread(title: "No followers", message: "This user has no followers", buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollower(for: user.login)
        dismissVC()
    }
}

// MARK: GFRepoItemVCDelegate
// this extion iclude the acutial implemetation about what delegate does
extension UserInfoVC: GFRepoItemVCDelegate {
    
    // this method will be called in userinfoVC's subclass
    func didTapGitHubProfile(for user: User) {
        // the url indicate the user's repo
        guard let url = URL(string: user.htmlUrl ) else {
            pressntGFAlerOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "OK")
            return
        }
        // this method call from viewcontroller extention
        presentSafariVC(for: url)
    }
}
