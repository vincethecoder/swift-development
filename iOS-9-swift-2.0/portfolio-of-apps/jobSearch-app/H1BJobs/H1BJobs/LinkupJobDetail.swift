//
//  LinkupJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/17/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

class LinkupJobDetail: NSObject {
    
    var job_title: String!
    var job_title_link: String?
    var job_company: String?
    var job_tag: String?
    var job_location: String?
    var job_zip: NSNumber?
    var job_date_added: String?
    var job_date_posted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date: Date = dateFormatter.date(from: job_date_added!)!
        return date
    }
    var job_description: String?
    var job_country: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
}
