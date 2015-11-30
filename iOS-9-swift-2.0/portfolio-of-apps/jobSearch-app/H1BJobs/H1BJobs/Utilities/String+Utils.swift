//
//  NSString+Utils.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

extension String {
    
    var escapedString: String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }

    var parseJSONString: AnyObject? {

        do {
            let jsonData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            if let _ = jsonData,
                JSON = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .MutableContainers) as? NSDictionary {
                return JSON
            }
            // No JSON Data returned
            return jsonData
        } catch let error as NSError {
            return error
        }
    }
    
    func urlForJobBoard(jobBoard: JobCategory, keywords: String) -> String {
        return JobUtils.init(category:jobBoard, search:keywords).requestURL
    }
    
    func cbJobPostDateDayMonthYear() -> NSDate {
        let postDateTimeArr =  self.characters.split{$0 == " "}.map(String.init) // 11/18/2015 11:59:48 AM
        let postDate = postDateTimeArr[0]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.dateFromString(postDate)!
    }
    
    func diceJobPostDateDayMonthYear() -> NSDate {
        let postDate = self
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(postDate)!
    }
}

