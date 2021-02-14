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
    var jobdetail: Any
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
    
    var companyLogoName: String {
        if jobdetail is DiceJobDetail {
            return "dice_logo"
        } else if jobdetail is CBJobDetail {
            return "cb_logo"
        } else if jobdetail is IndeedJobDetail {
            return "indeed_logo"
        } else if jobdetail is LinkupJobDetail {
            return "linkup_logo"
        }
        return "default_logo"
    }
    
    var companyLogo: UIImage {
        if let image = UIImage(named: companyLogoName) {
            return image
        }
        return UIImage()
    }

    init(title: String?, company: String?, location: String?, date: Date?, detail: Any) {
        self.title = title ?? ""
        self.company = company ?? ""
        self.location = location ?? "USA"
        self.postdate = date ?? Date()
        self.jobdetail = detail
    }
}
