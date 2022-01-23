//
//  NetWorkManager.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/18.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import UIKit

class NetWorkManager {
    // share one instance entire app
    static let shared = NetWorkManager()
    private let baseURL = "https://api.github.com/"
    let cache = NSCache<NSString, UIImage>()
    
    // to create the instance within this class, we need to initialize class its self
    private init() { }
 
    // This method allow app access the github api
    // and then, get the user's data
    // when error oucrre, log the error message and show the alert dialog
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUserName))
            return
        }
        
        // This task implement the error handling.
        // First, we define the three kind of the check components(data,response,error).
        // We should identify the error type from step to step.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 1: check the error exit or not
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            // 2. check the response exist and stauscode is sucess
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            // 3. check the data exist or not
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            // Declare the do try catch because the decoding cause unexpected error
            do {
                let decoder  = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
}
