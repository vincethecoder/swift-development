//
//  CareerBuilderJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJob {
    
    var jobListings: [CBJobDetail] = []
    
    var hasResults: Bool {
        return jobListings.count > 0
    }
    
    var jobData = [String: AnyObject]() {
        didSet {
            if let responseJobSearch = jobData["ResponseJobSearch"] as? [String: AnyObject],
               let results = responseJobSearch["Results"] as? [String: AnyObject],
               let searchResults = results["JobSearchResult"] as? [[String: AnyObject]] {
                jobListings = searchResults.map { CBJobDetail(dict: $0) }
            }
            
        }
    }
}
