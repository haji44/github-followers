//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/27.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class GFDataLoadingVC: UIViewController {

    var containerView: UIView!
    
    // This method is responsible for showing loading icon
    // you should call this method before doing netowork call or something update
    func showLoadingView() {
        // 1. initialize the view
        containerView = UIView(frame: view.bounds) // bounds reffert to abosolute value
        view.addSubview(containerView)
        
        // 2. setting the look
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        // 3. change the opacity by animation
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        // 4. indicator for showing the icon
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // containerViw is a superview of acitivityIndicator
            // so you chose specified super view
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    // This method is responsible for dissmiss the loading view
    // you should along with loading view
    func dismissLodingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }

    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
