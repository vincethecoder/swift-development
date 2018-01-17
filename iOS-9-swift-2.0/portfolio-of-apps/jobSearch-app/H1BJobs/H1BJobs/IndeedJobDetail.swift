//
//  IndeedJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/18/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

class IndeedJobDetail: NSObject {
    
    var jobtitle: String?
    var company: String?
    var city: String?
    var state: String?
    var country: String?
    var formattedLocation: String?
    var source: String?
    var date: String?
    var datePosted: Date? {
        guard let currentDate = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        return dateFormatter.date(from: currentDate)
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
    
    init(dict: [String: Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }

}
