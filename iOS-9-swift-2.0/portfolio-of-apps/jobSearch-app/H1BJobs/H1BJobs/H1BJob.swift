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
            } else if jobdetail.isKindOfClass(LinkupJobDetail) {
                let linkupJob = jobdetail as? LinkupJobDetail
                return (linkupJob?.job_title_link)!
            } else if jobdetail.isKindOfClass(IndeedJobDetail) {
                let indeedJob = jobdetail as? IndeedJobDetail
                return (indeedJob?.url)!
            }
            return "" // default url
        }
    }
    var companyLogo: UIImage {
        get {
            if jobdetail.isKindOfClass(DiceJobDetail) {
                return UIImage(named: "dice_logo")!
            } else if jobdetail.isKindOfClass(CBJobDetail) {
                return UIImage(named: "cb_logo")!
            } else if jobdetail.isKindOfClass(IndeedJobDetail) {
                return UIImage(named: "indeed_logo")!
            } else if jobdetail.isKindOfClass(LinkupJobDetail) {
                return UIImage(named: "linkup_logo")!
            }
            return UIImage()
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
