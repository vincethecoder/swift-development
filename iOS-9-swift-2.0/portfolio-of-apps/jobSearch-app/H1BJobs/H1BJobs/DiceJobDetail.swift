//
//  DiceJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct DiceJobDetail {

    var detailUrl: String?
    var jobTitle: String?
    var company: String?
    var location: String?
    var postdate: Date?
    var date: String? {
        didSet {
            postdate = date?.diceJobPostDateDayMonthYear
        }
    }
    
    init(dict: [String: AnyObject]) {
        if let url = dict["detailUrl"] as? String {
            detailUrl = url
        }
        
        if let title = dict["jobTitle"] as? String {
            jobTitle = title
        }
        
        if let _company = dict["company"] as? String {
            company = _company
        }
        
        if let _location = dict["location"] as? String {
            location = _location
        }
        
        if let _postdate = dict["postdate"] as? Date {
            postdate = _postdate
        }
        
        if let _date = dict["date"] as? String {
            date = _date
        }
    }
}
