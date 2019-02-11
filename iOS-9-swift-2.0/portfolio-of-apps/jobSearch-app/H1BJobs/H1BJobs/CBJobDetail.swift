//
//  CBJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJobDetail {

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
    var postedDate: Date?
    var postedTime: String? {
        set {
            if let date = newValue {
                postedDate = date.cbJobPostDateDayMonthYear
            }
        }
        get {
            if let value = postedDate {
                return "\(value)"
            }
            return nil
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
        if let _company = dict["Company"] as? String {
            company = _company
        }
        
        if let _companyDID = dict["CompanyDID"] as? String {
            companyDID = _companyDID
        }
        
        if let _companyDetailsURL = dict["CompanyDetailsURL"] as? String {
            companyDetailsURL = _companyDetailsURL
        }
        
        if let _DID = dict["DID"] as? String {
            DID = _DID
        }
        
        if let _onetCode = dict["OnetCode"] as? String {
            onetCode = _onetCode
        }
        
        if let _oNetFriendlyTitle = dict["ONetFriendlyTitle"] as? String {
            oNetFriendlyTitle = _oNetFriendlyTitle
        }
        
        if let _descriptionTeaser = dict["DescriptionTeaser"] as? String {
            descriptionTeaser = _descriptionTeaser
        }
        
        if let _distance = dict["Distance"] as? String {
            distance = _distance
        }
        
        if let _employmentType = dict["EmploymentType"] as? String {
            employmentType = _employmentType
        }

        if let _educationRequired = dict["EducationRequired"] as? String {
            educationRequired = _educationRequired
        }
        
        if let _experienceRequired = dict["ExperienceRequired"] as? String {
            experienceRequired = _experienceRequired
        }
  
        if let _jobDetailsURL = dict["JobDetailsURL"] as? String {
            jobDetailsURL = _jobDetailsURL
        }
        
        if let _jobServiceURL = dict["JobServiceURL"] as? String {
            jobServiceURL = _jobServiceURL
        }

        if let _location = dict["Location"] as? String {
            location = _location
        }
        
        if let _displayCity = dict["DisplayCity"] as? String {
            displayCity = _displayCity
        }
        
        if let _streetAddress1 = dict["StreetAddress1"] as? String {
            streetAddress1 = _streetAddress1
        }
        
        if let _city = dict["City"] as? String {
            city = _city
        }
        
        if let _state = dict["State"] as? String {
            state = _state
        }
        
        if let _locationLatitude = dict["LocationLatitude"] as? Int {
            locationLatitude = _locationLatitude
        }
        
        if let _locationLongitude = dict["LocationLongitude"] as? Int {
            locationLongitude = _locationLongitude
        }
        
        if let _postedDate = dict["PostedDate"] as? Date {
            postedDate = _postedDate
        }
        
        if let _postedTime = dict["PostedTime"] as? String {
            postedTime = _postedTime
        }
        
        if let _pay = dict["Pay"] as? String {
            pay = _pay
        }
        
        if let _similarJobsURL = dict["SimilarJobsURL"] as? String {
            similarJobsURL = _similarJobsURL
        }
        
        if let _companyImageURL = dict["CompanyImageURL"] as? String {
            companyImageURL = _companyImageURL
        }
        
        if let _jobBrandingIcons = dict["JobBrandingIcons"] as? String {
            jobBrandingIcons = _jobBrandingIcons
        }
        
        if let _applyRequirements = dict["ApplyRequirements"] as? String {
            applyRequirements = _applyRequirements
        }

        if let _skills = dict["Skills"] as? [String : AnyObject] {
            skills = _skills
        }
        
        if let _jobLevel = dict["JobLevel"] as? String {
            jobLevel = _jobLevel
        }
        
        if let _jobTitle = dict["JobTitle"] as? String {
            jobTitle = _jobTitle
        }
    }
    
    var h1BEligible: Bool {
        let h1bFlag = "H1B"
        if DID?.range(of: h1bFlag) != nil && descriptionTeaser?.range(of: h1bFlag) != nil {
            return true
        } else if descriptionTeaser?.range(of: h1bFlag) != nil {
            return true
        } else if jobTitle?.range(of: h1bFlag) != nil {
            return true
        } else {
            return false
        }
    }

}
