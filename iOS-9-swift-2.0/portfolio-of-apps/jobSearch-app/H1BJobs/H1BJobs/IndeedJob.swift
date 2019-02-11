//
//  IndeedJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/18/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

struct IndeedJob {

    var jobListings = [IndeedJobDetail]()

    var jobData = [String: AnyObject]() {
        didSet {
            if let results = jobData["results"] as? [[String: AnyObject]] {
                jobListings = results.map { IndeedJobDetail(dict: $0) }
            }
        }
    }

}
