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
    static let shared   = NetWorkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()
    // to create the instance within this class, we need to initialize class its self
    private init() {
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
        
    }
    
    //    // This method allow app access the github api
    //    // and then, get the user's data
    //    // when error oucrre, log the error message and show the alert dialog
    //    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
    //        let endpoint = baseURL + "\(username)/followers?per_page=99&page=\(page)"
    //
    //        guard let url = URL(string: endpoint) else {
    //            completed(.failure(.invalidUserName))
    //            return
    //        }
    //
    //        // This task implement the error handling.
    //        // First, we define the three kind of the check components(data,response,error).
    //        // We should identify the error type from step to step.
    //        let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //            // 1: check the error exit or not
    //            if let _ = error {
    //                completed(.failure(.unableToComplete))
    //                return
    //            }
    //            // 2. check the response exist and stauscode is sucess
    //            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
    //                completed(.failure(.invalidResponse))
    //                return
    //            }
    //            // 3. check the data exist or not
    //            guard let data = data else {
    //                completed(.failure(.invalidData))
    //                return
    //            }
    //            // Declare the do try catch because the decoding cause unexpected error
    //            do {
    //                let decoder  = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                let followers = try decoder.decode([Follower].self, from: data)
    //                completed(.success(followers))
    //            } catch {
    //                completed(.failure(.invalidData))
    //            }
    //        }
    //
    //        task.resume()
    //    }
    
    // This method allow app access the github api
    // and then, get the user's data
    // when error oucrre, log the error message and show the alert dialog
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=99&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUserName
        }
        
        // This task implement the error handling.
        // First, we define the three kind of the check components(data,response,error).
        // We should identify the error type from step to step.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 2. check the response exist and stauscode is sucess
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        // Declare the do try catch because the decoding cause unexpected error
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + username
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUserName
        }
        // This task implement the error handling.
        // First, we define the three kind of the check components(data,response,error).
        // We should identify the error type from step to step.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 2. check the response exist and stauscode is sucess
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        // Declare the do try catch because the decoding cause unexpected error
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        // we need to convert NSString to Swift String
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        
        guard let url = URL(string: urlString ) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
