//
//  CareerBuilderJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class CBJob: NSObject {
    
    var jobListings:[CBJobDetail] = []
    var searchResponse:CBJobResponse?
    var ResponseJobSearch = [String: AnyObject]() {
        didSet {
            let response = CBJobResponse.init(dict: ResponseJobSearch)
            searchResponse = response
            jobListings = (searchResponse?.jobListings)!
        }
    }
    
    var hasResults: Bool {
        return jobListings.count > 0
    }
    
    var jobData = [String: AnyObject]() {
        didSet {
            self.setValuesForKeysWithDictionary(jobData)
        }
    }
}
