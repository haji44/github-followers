//
//  String+Ext.swift.swift
//  GHFollowers
//
//  Created by kitano hajime on 2022/01/25.
//  Copyright © 2022 Sean Allen. All rights reserved.
//

import Foundation

// This extention allow the app to convert date to string and vicevsera
extension String {
    
    // This method return Japan locale current time
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    // This method make sure the expression which will show the display style
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
    
}
