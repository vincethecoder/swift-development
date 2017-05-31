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
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
    var removeBadChars: String {
        let badchar: CharacterSet = CharacterSet(charactersIn: "\"\\\t\n\r\'")
        return (self.components(separatedBy: badchar) as NSArray).componentsJoined(by: "")
    }

    var parseJSONString: AnyObject? {

        do {
            let jsonData = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
            if let _ = jsonData,
                let JSON = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as? NSDictionary {
                return JSON
            }
            // No JSON Data returned
            return jsonData as AnyObject
        } catch let error as NSError {
            return error
        }
    }
    
    func urlForJobBoard(_ jobBoard: JobCategory, keywords: String) -> String {
        return JobUtils.init(category:jobBoard, search:keywords).requestURL
    }
    
    func cbJobPostDateDayMonthYear() -> Date {
        let postDateTimeArr =  self.characters.split{$0 == " "}.map(String.init) // 11/18/2015 11:59:48 AM
        let postDate = postDateTimeArr[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.date(from: postDate)!
    }
    
    func diceJobPostDateDayMonthYear() -> Date {
        let postDate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: postDate)!
    }
    
    func isValidSponsoredJob() -> Bool {
        if self.lowercased().range(of: "unable") == nil &&
           self.lowercased().range(of: "not") == nil &&
           self.lowercased().range(of: "no") == nil &&
           self.lowercased().range(of: "won't") == nil &&
           self.lowercased().range(of: "unwilling") == nil &&
           self.lowercased().range(of: "cannot") == nil {
                return contatinsH1B()
        }
        return false
    }

    func contatinsH1B() -> Bool {
        if self.lowercased().range(of: "h1b") != nil ||
           self.lowercased().range(of: "h-1b") != nil ||
            self.lowercased().range(of: "h1-b") != nil {
                return true
        }
        return false
    }
    
    func matchedKeyword(_ keyword: String) -> Bool {
        if keyword.characters.count == 0 {
            return true;
        } else {
            return self.lowercased().range(of: keyword.lowercased()) != nil
        }
    }

}

