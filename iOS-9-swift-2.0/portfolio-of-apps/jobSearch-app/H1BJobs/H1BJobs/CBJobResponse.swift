//
//  CBJobResponse.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class CBJobResponse: NSObject {
    
    var Errors: NSError?
    var TimeResponseSent: String?
    var TimeElapsed: String?
    var TotalPages: String?
    var TotalCount: String?
    var FirstItemIndex: String?
    var LastItemIndex: String?
    var SearchMetaData: [String: AnyObject]?
    var jobListings:[CBJobDetail] = []
    var RequestEvidenceID: String?
    
    var Results: [String : AnyObject] = [String : AnyObject]() {
        didSet {
            let searchReaults = Results["JobSearchResult"] as! NSArray
            for searhResult in searchReaults {
                let dict = searhResult as! [String : AnyObject]
                let job = CBJobDetail.init(dict: dict)
                jobListings.append(job)
            }
        }
    }

    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
}
