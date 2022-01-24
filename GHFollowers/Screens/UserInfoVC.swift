//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/23.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView() // this view will be consist of three child view
    
    var username: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        // apply the barbutton to navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        layoutUI()
        
        NetWorkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let error):
                self.pressntGFAlerOnMainThread(title: "something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    // This method modify the ui setting of headerview which will be assinged new child view
    func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
            
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
