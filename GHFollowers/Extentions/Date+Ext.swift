//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/25.
//  Copyright © 2022 Sean Allen. All rights reserved.
//  Below the link is useful for date expression
//  https://nsdateformatter.com/

import Foundation

extension Date {
    
    // This method plays an hub role in formatting
    // and then it's called string extention
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
