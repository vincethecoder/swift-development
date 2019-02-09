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
    var postdate: Date
    var jobdetail: NSObject
    var jobUrl: String {
        get {
            if let dicejob = jobdetail as? DiceJobDetail {
                return (dicejob.detailUrl)!
            } else if let cbJobDetail = jobdetail as? CBJobDetail {
                return (cbJobDetail.detailUrl)!
            } else if let linkupJob = jobdetail as? LinkupJobDetail {
                return (linkupJob.job_title_link)!
            } else if let indeedJob = jobdetail as? IndeedJobDetail {
                return (indeedJob.url)!
            }
            return "" // default url
        }
    }
    var companyLogo: UIImage {
        get {
            if let _ = jobdetail as? DiceJobDetail {
                return UIImage(named: "dice_logo")!
            } else if let _ = jobdetail as? CBJobDetail {
                return UIImage(named: "cb_logo")!
            } else if let _ = jobdetail as? IndeedJobDetail {
                return UIImage(named: "indeed_logo")!
            } else if let _ = jobdetail as? LinkupJobDetail {
                return UIImage(named: "linkup_logo")!
            }
            return UIImage()
        }
    }

    init(title: String, company: String, location: String, date: Date, detail: NSObject) {
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
        self.postdate = Date()
        self.jobdetail = NSObject()
    }
}
