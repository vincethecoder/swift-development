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
    var jobdetail: Any?
    var jobUrl: String {
        get {
            if let dicejob = jobdetail as? DiceJobDetail {
                return dicejob.detailUrl ?? ""
            } else if let cbJobDetail = jobdetail as? CBJobDetail {
                return cbJobDetail.detailUrl ?? ""
            } else if let linkupJob = jobdetail as? LinkupJobDetail {
                return linkupJob.job_title_link ?? ""
            } else if let indeedJob = jobdetail as? IndeedJobDetail {
                return indeedJob.url ?? ""
            }
            return "" // default url
        }
    }
    var companyLogo: UIImage {
        get {
            if jobdetail is DiceJobDetail, let diceLogo =  UIImage(named: "dice_logo") {
                return diceLogo
            } else if jobdetail is CBJobDetail, let cbLogo = UIImage(named: "cb_logo") {
                return cbLogo
            } else if jobdetail is IndeedJobDetail, let indeedLogo = UIImage(named: "indeed_logo") {
                return indeedLogo
            } else if jobdetail is LinkupJobDetail, let linkupLogo = UIImage(named: "linkup_logo") {
                return linkupLogo
            }
            return UIImage()
        }
    }

    init(title: String, company: String, location: String, date: Date, detail: Any? = nil) {
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
    }
}
