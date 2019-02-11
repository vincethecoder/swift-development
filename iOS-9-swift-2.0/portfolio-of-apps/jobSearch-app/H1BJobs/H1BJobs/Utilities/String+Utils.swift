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
    
    func urlForJobBoard(jobBoard: JobCategory, keywords: String) -> String {
        return JobUtils.init(category:jobBoard, search:keywords).requestURL
    }
    
    var cbJobPostDateDayMonthYear: Date {
        let postDateTimeArr =  self.split{$0 == " "}.map(String.init) // 11/18/2015 11:59:48 AM
        let postDate = postDateTimeArr[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.date(from: postDate)! as Date
    }
    
    var diceJobPostDateDayMonthYear: Date {
        let postDate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: postDate)! as Date
    }
    
    var isValidSponsoredJob: Bool {
        return self.lowercased().range(of: "unable") == nil &&
               self.lowercased().range(of: "not") == nil &&
               self.lowercased().range(of: "no") == nil &&
               self.lowercased().range(of: "won't") == nil &&
               self.lowercased().range(of: "unwilling") == nil &&
               self.lowercased().range(of: "cannot") == nil
    }

}
