//
//  CBJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJobDetail {
    
    var onet17Title: String?
    var caroteneV3Title: String?
    var teaser: String?
    var onet17Code: String?
    var experienceRequired: String?
    var location: String?
    var jobServiceURL: String?
    var jobDetailsURL: String?
    var educationRequired: String?
    var locationLongitude: String?
    var similarJobsURL: String?
    var state: String?
    var pay: String?
    var caroteneCode: Double?
    var locationLatitude: String?
    var employmentType: String?
    var jobTitle: String?
    var onetTitle: String?
    var postedDate: String?
    var onetCode: String?
    var applyRequirements: String?
    var city: String?
    var jobID: String?
    var jobLevel: String?

    var postedTime: String? {
        set {
            if let date = newValue {
                postedDate = "\(date.cbJobPostDateDayMonthYear())"
            }
        }
        get {
            return "\(String(describing: postedDate))"
        }
    }
    var detailUrl: String? {
        get {
            if let id = jobID {
                return "http://mobile.careerbuilder.com/seeker/job/\(id)"
            }
            return ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case onet17Title = "ONet17FriendlyTitle"
        case caroteneV3Title = "CaroteneV3FriendlyTitle"
        case teaser = "DescriptionTeaser"
        case onet17Code = "ONet17Code"
        case experienceRequired = "ExperienceRequired"
        case location = "Location"
        case jobServiceURL = "JobServiceURL"
        case jobDetailsURL = "JobDetailsURL"
        case postedTime = "PostedTime"
        case educationRequired = "EducationRequired"
        case locationLongitude = "LocationLongitude"
        case similarJobsURL = "SimilarJobsURL"
        case state = "State"
        case pay = "Pay"
        case caroteneCode = "CaroteneV3Code"
        case locationLatitude = "LocationLatitude"
        case employmentType = "EmploymentType"
        case jobTitle = "JobTitle"
        case onetTitle = "ONetFriendlyTitle"
        case postedDate = "PostedDate"
        case onetCode = "OnetCode"
        case applyRequirements = "ApplyRequirements"
        case city = "City"
        case jobID = "DID"
        case jobLevel = "JobLevel"
    }

    init(dict: [String: Any]) {
        jobID = dict["DID"] as? String
        jobDetailsURL = dict["JobDetailsURL"] as? String
        jobID = dict["DID"] as? String
        onetCode = dict["OnetCode"] as? String
        onetTitle = dict["ONetFriendlyTitle"] as? String
        employmentType = dict["EmploymentType"] as? String
        educationRequired = dict["EducationRequired"] as? String
        experienceRequired = dict["ExperienceRequired"] as? String
        jobDetailsURL = dict["JobDetailsURL"] as? String
        jobServiceURL = dict["JobServiceURL"] as? String
        location = dict["Location"] as? String
        city = dict["City"] as? String
        city = dict["City"] as? String
        state = dict["State"] as? String
        locationLatitude = dict["LocationLatitude"] as? String
        locationLongitude = dict["LocationLongitude"] as? String
        postedDate = dict["PostedDate"] as? String
        postedTime = dict["PostedTime"] as? String
        pay = dict["Pay"] as? String
        similarJobsURL = dict["SimilarJobsURL"] as? String
        applyRequirements = dict["ApplyRequirements"] as? String
        jobLevel = dict["JobLevel"] as? String
        jobTitle = dict["JobTitle"] as? String
        caroteneV3Title = dict["CaroteneV3Code"] as? String
    }
    
    func h1BEligible() -> Bool {
        return jobTitle?.range(of: "H1B") != nil
    }
}

extension CBJobDetail: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(onet17Title, forKey: .onet17Title)
            try container.encode(caroteneV3Title, forKey: .caroteneV3Title)
            try container.encode(teaser, forKey: .teaser)
            try container.encode(onet17Code, forKey: .onet17Code)
            try container.encode(experienceRequired, forKey: .experienceRequired)
            try container.encode(location, forKey: .location)
            try container.encode(jobServiceURL, forKey: .jobServiceURL)
            try container.encode(postedTime, forKey: .postedTime)
            try container.encode(educationRequired, forKey: .educationRequired)
            try container.encode(locationLongitude, forKey: .locationLongitude)
            try container.encode(similarJobsURL, forKey: .similarJobsURL)
            try container.encode(state, forKey: .state)
            try container.encode(pay, forKey: .pay)
            try container.encode(caroteneCode, forKey: .caroteneCode)
            try container.encode(locationLatitude, forKey: .locationLatitude)
            try container.encode(employmentType, forKey: .employmentType)
            try container.encode(jobTitle, forKey: .jobTitle)
            try container.encode(onetTitle, forKey: .onetTitle)
            try container.encode(applyRequirements, forKey: .applyRequirements)
            try container.encode(city, forKey: .city)
            try container.encode(jobID, forKey: .jobID)
            try container.encode(jobLevel, forKey: .jobLevel)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension CBJobDetail: Decodable {
    
    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            onet17Title = try values.decode(String.self, forKey: .onet17Title)
            caroteneV3Title = try values.decode(String.self, forKey: .caroteneV3Title)
            teaser = try values.decode(String.self, forKey: .teaser)
            onet17Code = try values.decode(String.self, forKey: .onet17Code)
            experienceRequired = try values.decode(String.self, forKey: .experienceRequired)
            location = try values.decode(String.self, forKey: .location)
            jobServiceURL = try values.decode(String.self, forKey: .jobServiceURL)
            jobDetailsURL = try values.decode(String.self, forKey: .jobDetailsURL)
            postedTime = try values.decode(String.self, forKey: .postedTime)
            educationRequired = try values.decode(String.self, forKey: .educationRequired)
            locationLongitude = try values.decode(String.self, forKey: .locationLongitude)
            similarJobsURL = try values.decode(String.self, forKey: .similarJobsURL)
            state = try values.decode(String.self, forKey: .state)
            pay = try values.decode(String.self, forKey: .pay)
            caroteneCode = try values.decode(Double.self, forKey: .caroteneCode)
            locationLatitude = try values.decode(String.self, forKey: .locationLatitude)
            employmentType = try values.decode(String.self, forKey: .employmentType)
            jobTitle = try values.decode(String.self, forKey: .jobTitle)
            onetTitle = try values.decode(String.self, forKey: .onetTitle)
            postedDate = try values.decode(String.self, forKey: .postedDate)
            onetCode = try values.decode(String.self, forKey: .onetCode)
            applyRequirements = try values.decode(String.self, forKey: .applyRequirements)
            city = try values.decode(String.self, forKey: .city)
            jobID = try values.decode(String.self, forKey: .jobID)
            jobLevel = try values.decode(String.self, forKey: .jobLevel)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
