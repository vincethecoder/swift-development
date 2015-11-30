//
//  Date+Formatter.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

extension NSDate {
    
    private func baseDateFormatter(dateFormat:String) -> NSDateFormatter {
        let formatter = NSDateFormatter.init()
        formatter.timeZone = NSTimeZone(name: "America/New_York")
        formatter.dateFormat = dateFormat
        return formatter
    }

    /* 
    Date string formatted as "Jan 6" or "Nov 16" 
    */
    func wordMonthDayString() -> String {
        let formatter = baseDateFormatter("MMM d")
        return formatter.stringFromDate(self)
    }
    
    /* 
    Date string formatted as "January 6" or "November 16" 
    */
    func wordFullMonthDayString() -> String {
        let formatter = baseDateFormatter("MMMM d")
        return formatter.stringFromDate(self)
    }
    
    /* 
    Date string formatted as "Jan 06, 2010" or "Nov 16, 2015" 
    */
    func wordMonthDayYearString() -> String {
        let formatter = baseDateFormatter("MMM d, yyyy")
        return formatter.stringFromDate(self)
    }
    
    /* 
    Date string formatted as "January 6, 2010" or "November 7, 2015" 
    */
    func wordFullMonthDayYearString() -> String {
        let formatter = baseDateFormatter("MMMM d, yyyy")
        return formatter.stringFromDate(self)
    }

}
