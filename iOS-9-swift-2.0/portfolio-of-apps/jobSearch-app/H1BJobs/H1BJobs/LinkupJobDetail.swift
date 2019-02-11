//
//  LinkupJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/17/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

struct LinkupJobDetail {
    
    var job_title: String?
    var job_title_link: String?
    var job_company: String?
    var job_tag: String?
    var job_location: String?
    var job_zip: NSNumber?
    var job_date_added: String?
    var job_date_posted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date: Date = dateFormatter.date(from: job_date_added!)! as Date
        return date
    }
    var job_description: String?
    var job_country: String?
    
    init(dict: [String: AnyObject]) {
        if let title = dict["job_title"] as? String {
            job_title = title
        }
        
        if let titleLink = dict["job_title_link"] as? String {
            job_title_link = titleLink
        }
        
        if let company = dict["job_company"] as? String {
            job_company = company
        }
        
        if let tag = dict["job_tag"] as? String {
            job_tag = tag
        }
        
        if let location = dict["job_location"] as? String {
            job_location = location
        }
        
        if let zip = dict["job_zip"] as? NSNumber {
            job_zip = zip
        }
        
        if let added = dict["job_date_added"] as? String {
            job_date_added = added
        }
        
        if let desc = dict["job_description"] as? String {
            job_description = desc
        }
        
        if let country = dict["job_country"] as? String {
            job_country = country
        }
    }
}
