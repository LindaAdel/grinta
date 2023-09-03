//
//  DateManager.swift
//  grinta
//
//  Created by Linda adel on 26/08/2023.
//

import Foundation

class DateManager {
    static let currentTimeZone = TimeZone.current.description.components(separatedBy: " ").first
    private let dateFormatter: DateFormatter
    
    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = TimeZone.current
    }
    
    private func formatDate(date: Date, format: String) -> String {
        self.dateFormatter.dateFormat = format
        return self.dateFormatter.string(from: date)
    }
    
    func getCurrentDate() -> String {
        let currentDate = Date()
        return formatDate(date: currentDate, format: "yyyy-MM-dd")
    }
    
    func getScheduledMatchDate(utcDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let utcDate = dateFormatter.date(from: utcDate) {
            return formatDate(date: utcDate, format: "yyyy-MM-dd")
        }
        
        return ""
    }
    
    func getScheduledMatchTimeInLocalTime(utcDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let currentTimeZone = TimeZone.current.description
        dateFormatter.timeZone = TimeZone(identifier: currentTimeZone)
       
        if let convertedDate = dateFormatter.date(from: utcDate) {
            return formatDate(date: convertedDate, format: "HH:mm")
        }
        
        return ""
    }
}
