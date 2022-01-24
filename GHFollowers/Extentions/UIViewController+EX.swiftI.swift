//
//  UIViewController+EX.swiftI.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/17.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    func pressntGFAlerOnMainThread(title: String, message:String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAleartVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariVC(for url: URL) {
        // create safari view and then show up for user
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    
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
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        // 4. indicator for showing the icon
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()  
    }
    
    
    // This method is responsible for dissmiss the loading view
    // you should along with loading view
    func dismissLodingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }

    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
