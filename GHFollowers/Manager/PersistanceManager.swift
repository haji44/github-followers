//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/25.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

// this enum is used to determine which implemtation will excute
enum PersistanceActionType {
    case add, remove
}

// This enum is responsible for persistance data by using userdefaults
enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    // Key is needed to coincide the data
    enum Keys { static let favorites = "favorites" }
    
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, comlpleted: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites): // this line is needed to treat favorites to change muttable
                switch actionType {
                // before doing add, we need to  make sure that favorites doesn't exist in user defaults
                case .add:
                    guard !favorites.contains(favorite) else {
                        comlpleted(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                
                // the conditions of removing data is User's login identical to aurguments
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                // because save method return GFError, so we can use this as coopleted's aurguments
                comlpleted(save(favorites: favorites))

            case .failure(let error):
                comlpleted(error)
            }
        }
    }
    
    
    // this method is used to retrieve follower from userdefaults
    // decoder is needed to retrieve data
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        // when acess the user defaults for the first time
        // favorite data is nil so then return empty array
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        // Declare the do try catch because the decoding cause unexpected error
        do {
            let decoder  = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    // when saving data, it's needed to decode the user data
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
