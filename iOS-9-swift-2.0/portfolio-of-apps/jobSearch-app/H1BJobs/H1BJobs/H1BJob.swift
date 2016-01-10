//
//  H1BJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class H1BJob: NSObject {
    
    var title: String
    var company: String
    var location: String
    var postdate: NSDate
    var jobdetail: NSObject
    var jobUrl: String {
        get {
            if jobdetail.isKindOfClass(DiceJobDetail) {
                let dicejob = jobdetail as? DiceJobDetail
                return (dicejob?.detailUrl)!
            } else if jobdetail.isKindOfClass(CBJobDetail) {
                let cbJobDetail = jobdetail as? CBJobDetail
                return (cbJobDetail?.detailUrl)!
            }
            return "" // default url
        }
    }

    init(title: String, company: String, location: String, date: NSDate, detail: NSObject) {
        self.title = title
        self.company = company
        self.location = location
        self.postdate = date
        self.jobdetail = detail
    }
    
    override init() {
        self.title = String()
        self.company = String()
        self.location = String()
        self.postdate = NSDate()
        self.jobdetail = NSObject()
    }
}
