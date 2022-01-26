//
//  UIViewController+EX.swiftI.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/17.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
import SafariServices


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
    

}
