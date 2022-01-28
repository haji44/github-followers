//
//  GFError.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/24.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName    =  "This username created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request, Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid"
    case unableToFavorite   = "There was an error favoriting the user"
    case alreadyInFavorites = "You've already favorited this user. You must Really like them!"
}
