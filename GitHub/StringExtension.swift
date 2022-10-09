//
//  StringExtension.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

extension String {
    func toDate(formate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {
    
    static var backendFormat: String {
        return "yyyy-MM-ddThh:mm:ssZ"
    }
    
    static var appFormat: String {
        return "dd MMM"
    }
    
    func toString(formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
