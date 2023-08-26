//
//  DateManager.swift
//  grinta
//
//  Created by Linda adel on 26/08/2023.
//

import Foundation

class DateManager {
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
    
    func getScheduledMatchTimeInLocalTime(utcDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let utcDate = dateFormatter.date(from: utcDate) {
            return formatDate(date: utcDate, format: "HH:mm")
        }
        
        return ""
    }
}
