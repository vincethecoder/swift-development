//
//  Date+Formatter.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

extension Date {
    
    private func baseDateFormatter(dateFormat:String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateFormat = dateFormat
        return formatter
    }

    /*
    Date string formatted as "Jan" or "Nov"
    */
    func wordMonthString() -> String {
        let formatter = baseDateFormatter(dateFormat: "MMM")
        return formatter.string(from: self)
    }
    
    /*
    Date string formatted as "6" or "16"
    */
    func wordDayString() -> String {
        let formatter = baseDateFormatter(dateFormat: "d")
        return formatter.string(from: self)
    }
    
    /* 
    Date string formatted as "Jan 6" or "Nov 16" 
    */
    func wordMonthDayString() -> String {
        let formatter = baseDateFormatter(dateFormat: "MMM d")
        return formatter.string(from: self)
    }
    
    /* 
    Date string formatted as "January 6" or "November 16" 
    */
    func wordFullMonthDayString() -> String {
        let formatter = baseDateFormatter(dateFormat: "MMMM d")
        return formatter.string(from: self)
    }
    
    /* 
    Date string formatted as "Jan 06, 2010" or "Nov 16, 2015" 
    */
    func wordMonthDayYearString() -> String {
        let formatter = baseDateFormatter(dateFormat: "MMM d, yyyy")
        return formatter.string(from: self)
    }
    
    /* 
    Date string formatted as "January 6, 2010" or "November 7, 2015" 
    */
    func wordFullMonthDayYearString() -> String {
        let formatter = baseDateFormatter(dateFormat: "MMMM d, yyyy")
        return formatter.string(from: self)
    }

}
