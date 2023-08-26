//
//  DateManagerTests.swift
//  grintaTests
//
//  Created by Linda adel on 26/08/2023.
//

import XCTest

final class DateManagerTests: XCTestCase {
    var dateManager: DateManager!
    
    override func setUp() {
        super.setUp()
        dateManager = DateManager()
    }
    
    override func tearDown() {
        dateManager = nil
        super.tearDown()
    }
    
    func testGetCurrentDate() {
        let expectedFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let expectedDate = formatDate(date: currentDate, format: expectedFormat)
        
        let currentDateResult = dateManager.getCurrentDate()
        
        XCTAssertEqual(currentDateResult, expectedDate)
    }
    
    func testGetScheduledMatchTimeInLocalTime() {
        let utcDate = "2023-08-26T10:30:00+0000"
        let expectedFormat = "HH:mm"
        let expectedTime = formatDate(dateString: utcDate, format: expectedFormat)
        
        let localTimeResult = dateManager.getScheduledMatchTimeInLocalTime(utcDate: utcDate)
        
        
        XCTAssertNotEqual(localTimeResult, expectedTime)
    }
    
    // Helper method to format dates
    func formatDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    // Helper method to format dates
        func formatDate(dateString: String, format: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = format
                return dateFormatter.string(from: date)
            }

            return ""
        }
}
