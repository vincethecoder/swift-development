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
    
    func isValidSponsoredJob() -> Bool {
        if self.lowercaseString.rangeOfString("unable") == nil &&
           self.lowercaseString.rangeOfString("not") == nil &&
           self.lowercaseString.rangeOfString("no") == nil &&
           self.lowercaseString.rangeOfString("won't") == nil &&
           self.lowercaseString.rangeOfString("unwilling") == nil &&
           self.lowercaseString.rangeOfString("cannot") == nil {
                return contatinsH1B()
        }
        return false
    }

    func contatinsH1B() -> Bool {
        if self.lowercaseString.rangeOfString("h1b") != nil ||
           self.lowercaseString.rangeOfString("h-1b") != nil ||
            self.lowercaseString.rangeOfString("h1-b") != nil {
                return true
        }
        return false
    }
    
    func matchedKeyword(keyword: String) -> Bool {
        if keyword.characters.count == 0 {
            return true;
        } else {
            return self.lowercaseString.rangeOfString(keyword.lowercaseString) != nil
        }
    }

}

