//
//  CBJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class CBJobDetail: NSObject {

    var company: String?
    var companyDID: String?
    var companyDetailsURL: String?
    var DID: String?
    var onetCode: String?
    var oNetFriendlyTitle: String?
    var descriptionTeaser: String?
    var distance: String?
    var employmentType: String?
    var educationRequired: String?
    var experienceRequired: String?
    var jobDetailsURL: String?
    var jobServiceURL: String?
    var location: String?
    var displayCity: String?
    var streetAddress1: String?
    var streetAddress2: String?
    var city: String?
    var state: String?
    var locationLatitude: Int?
    var locationLongitude: Int?
    var postedDate: NSDate?
    var postedTime: String? {
        set {
            if let date = newValue {
                postedDate = date.cbJobPostDateDayMonthYear()
            }
        }
        get {
            return "\(postedDate)"
        }
    }
    var pay: String?
    var similarJobsURL: String?
    var jobTitle: String?
    var companyImageURL: String?
    var jobBrandingIcons: String?
    var applyRequirements: String?
    var skills: [String : AnyObject]?
    var jobLevel: String?
    var detailUrl: String? {
        get {
            return "http://mobile.careerbuilder.com/seeker/job/\(DID!)"
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        company = dict["Company"] as? String
        companyDID = dict["CompanyDID"] as? String
        companyDetailsURL = dict["CompanyDetailsURL"] as? String
        DID = dict["DID"] as? String
        onetCode = dict["OnetCode"] as? String
        oNetFriendlyTitle = dict["ONetFriendlyTitle"] as? String
        descriptionTeaser = dict["DescriptionTeaser"] as? String
        distance = dict["Distance"] as? String
        employmentType = dict["EmploymentType"] as? String
        educationRequired = dict["EducationRequired"] as? String
        experienceRequired = dict["ExperienceRequired"] as? String
        jobDetailsURL = dict["JobDetailsURL"] as? String
        jobServiceURL = dict["JobServiceURL"] as? String
        location = dict["Location"] as? String
        displayCity = dict["DisplayCity"] as? String
        streetAddress1 = dict["StreetAddress1"] as? String
        city = dict["City"] as? String
        state = dict["State"] as? String
        locationLatitude = dict["LocationLatitude"] as? Int
        locationLongitude = dict["LocationLongitude"] as? Int
        postedDate = dict["PostedDate"] as? NSDate
        postedTime = dict["PostedTime"] as? String
        pay = dict["Pay"] as? String
        similarJobsURL = dict["SimilarJobsURL"] as? String
        companyImageURL = dict["CompanyImageURL"] as? String
        jobBrandingIcons = dict["JobBrandingIcons"] as? String
        applyRequirements = dict["ApplyRequirements"] as? String
        skills = dict["Skills"] as? [String : AnyObject]
        jobLevel = dict["JobLevel"] as? String
        jobTitle = dict["JobTitle"] as? String
    }

}
