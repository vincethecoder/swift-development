//
//  Linkup.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/17/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

struct LinkupJob {
    
    var jobListings = [LinkupJobDetail]()

    var jobData = [String: AnyObject]() {
        didSet {
            if let jobs = jobData["jobs"] as? [[String: AnyObject]] {
                jobListings = jobs.map { LinkupJobDetail(dict: $0) }
            }
        }
    }
}
