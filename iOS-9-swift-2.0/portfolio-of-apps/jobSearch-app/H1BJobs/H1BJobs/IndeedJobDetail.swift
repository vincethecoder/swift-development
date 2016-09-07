//
//  IndeedJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/18/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

class IndeedJobDetail: NSObject {
    
    var jobtitle: String!
    var company: String?
    var city: String?
    var state: String?
    var country: String?
    var formattedLocation: String?
    var source: String?
    var date: String?
    var datePosted: NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        if let date = date, formattedDate = dateFormatter.dateFromString(date) {
            return formattedDate
        }
        return nil
    }
    var snippet: String?
    var url: String?
    var jobkey: String?
    var formattedLocationFull: String?
    var sponsored: NSNumber?
    var expired: NSNumber?
    var indeedApply: NSNumber?
    var formattedRelativeTime: String?
    var noUniqueUrl: NSNumber?
    var onmousedown: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    

}