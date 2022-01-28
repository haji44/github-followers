//
//  GFAleartVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/16.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class GFAleartVC: UIViewController {
    
    let containerView = GFAlertContainerView()
    let titileLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLable(textAlignment: .center)
    let actionButton = GFButton(backGroundCoor: .systemPink, title: "OK")
    
    var alertTitile: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitile = title
        self.message = message
        self.buttonTitle = buttonTitle
        configureContainerView()
        configureTitleLable()
        configureActionButton()
        configureBodyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(containerView, titileLabel, actionButton, messageLabel)
        
        configureContainerView()
        configureTitleLable()
        configureActionButton()
        configureBodyLabel()
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitleLable() {
        titileLabel.text = alertTitile ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titileLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titileLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titileLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titileLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configureBodyLabel() {
        messageLabel.text = message ?? "Unable to comple request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titileLabel.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
