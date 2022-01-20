//
//  NetWorkManager.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/18.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

class NetWorkManager {
    // share one instance entire app
    static let shared = NetWorkManager()
    let baseURL = "https://api.github.com/"
    
    private init() { }
 
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseURL + "users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created an invalid request. Please try again.")
            return
        }
        
        // This task implement the error handling.
        // First, we define the three kind of the check components.
        // We should check error, respone and data's error.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 1: check the error exit or not
            if let _ = error {
                completed(nil, "Unable to complete your request, Please check your internet connection.")
                return
            }
            // 2. check the response exist and stauscode is sucess
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            // 3. check the data to parse into the decode
            guard let data = data else {
                completed(nil, "The data received from the server was invalid")
                return
            }
            // Declare the do try catch because the decoding cause anexpected error
            do {
                //
                let decoder  = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "The data received from the server was invalid")
            }
        }
        
        task.resume()
    }
    
}
