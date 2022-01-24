//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/21.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit
// This class has the setting about the image of avatar
class GFAvatarImageView: UIImageView {
    let cache = NetWorkManager.shared.cache
    // this code get the data from the asset folder
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    // initialize uiimage
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // configure the image setting
    // assing the placeholderImage to image
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    // This method is resiponsible for handling the image,
    // urlString equal to avatarURL
    func downLoadImage(from urlString: String) {
        // we need to convert NSString to Swift String
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString ) else { return }
        
        /// data: contains image
        /// response: httpurl respnse
        /// error:
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 1. check error
            if error != nil { return }
            // 2. check response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return  }
            // 3. check data
            guard let data = data else { return }
            // 4. assing the data to image
            guard let image = UIImage(data: data) else { return }
            
            // 5. set new cache
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async { self.image = image }
        }
        
        task.resume()
    }
    
    
}
