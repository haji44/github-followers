//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

// This class is distributed generic components
// and then this is treated as superclass
class GFItemInfoVC: UIViewController {

    let stackView = UIStackView()
    let itemInfoViewOne = GFItemView()
    let itemInfoViewTwo = GFItemView()
    let actionButton = GFButton()
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
    }
    
    // stackView is enable to arrange the view which contains addArrangedSubview
    // distribution and axis is needed to set up
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    // super view's setting are configured
    func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    

    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
