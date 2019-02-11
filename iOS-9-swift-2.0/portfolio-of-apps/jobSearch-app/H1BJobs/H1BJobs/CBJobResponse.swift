//
//  CBJobResponse.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJobResponse {
    
    var jobListings = [CBJobDetail]()

    init(dict: [String: AnyObject]) {
        if let searchResults = dict["JobSearchResult"] as? [[String: AnyObject]] {
            jobListings = searchResults.map { CBJobDetail(dict: $0) }
        }
    }
}
