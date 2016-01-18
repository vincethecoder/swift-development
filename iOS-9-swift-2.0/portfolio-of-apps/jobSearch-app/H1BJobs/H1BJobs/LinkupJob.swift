//
//  Linkup.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/17/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

class LinkupJob: NSObject {
    
    var criteria: NSObject?
    var result_info: NSObject?
    var title: String?
    var sponsored_listings: [NSObject]?
    var jobListings: [LinkupJobDetail] = []
    
    var jobs:[AnyObject] = [AnyObject]() {
        didSet {
            for items in jobs {
                let item = items as! [String : AnyObject]
                let jobItem: LinkupJobDetail = LinkupJobDetail(dict: item)
                jobListings.append(jobItem)
            }
        }
    }

    var jobData = [String: AnyObject]() {
        didSet {
            self.setValuesForKeysWithDictionary(jobData)
        }
    }
}
