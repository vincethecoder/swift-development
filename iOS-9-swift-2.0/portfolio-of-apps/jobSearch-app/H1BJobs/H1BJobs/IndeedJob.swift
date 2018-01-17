//
//  IndeedJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/18/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

class IndeedJob: NSObject {

    var jobListings: [IndeedJobDetail] = []
    var version: NSNumber?
    var query: String?
    var location: String?
    var highlight: NSNumber?
    var radius: NSNumber?
    var start: NSNumber?
    var end: NSNumber?
    var totalResults: NSNumber?
    var pageNumber: NSNumber?
    var dupefilter: NSNumber?
    
    var results = [Any]() {
        didSet {
            for items in results {
                if let item = items as? [String : Any] {
                    let jobItem: IndeedJobDetail = IndeedJobDetail(dict: item)
                    jobListings.append(jobItem)
                }
            }
        }
    }

    var jobData = [String: AnyObject]() {
        didSet {
            self.setValuesForKeys(jobData)
        }
    }

}
