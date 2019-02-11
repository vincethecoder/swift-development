//
//  JobsHelper.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

// Dice API Documentation: http://www.dice.com/common/content/util/apidoc/jobsearch.html
// Linkup API Documentation: http://www.linkup.com/developers/modify-direct-access.php
// Indeed API Documentation: https://ads.indeed.com/jobroll/xmlfeed
// CareerBuilder API Documentation: http://developer.careerbuilder.com/endpoints

enum JobCategory: String {
    case dice, careerBuilder, linkUp, indeed
}

/**
 Ensures the API_KEYS for the sponsored jobs are retrieved from the `info.plist` file.
 */
struct AppSecrets {
    static var diceURL: String {
       return "http://service.dice.com/api/rest/jobsearch/v1/simple.json?text=h1b,h1-b,h-1b"
    }
    
    static var careerBuilderURL: String {
        guard let dict = JobUtils.keys, let API_KEY = dict["CB_API_CLIENT_ID"] as? String else {
            return ""
        }
        return "http://api.careerbuilder.com/v1/jobsearch?&DeveloperKey=\(API_KEY)&ExcludeKeywords=%22unable%22%22cannot%22%22without%20sponsorship%22%22no%22%22Not%22%22part-time%22%22visa%20cap%20has%20been%20met%22%22unwilling%22&outputjson=true&booleanoperator=or&Keywords=h1b,h1-b,h-1b"
    }
    
    static var linkUpURL: String {
        guard let dict = JobUtils.keys, let API_KEY = dict["LINKUP_API_CLIENT_ID"] as? String else {
            return ""
        }
        return "http://www.linkup.com/developers/v-1/search-handler.js?api_key=\(API_KEY)&embedded_search_key=b06efca40addeb05131bef527b196953&orig_ip=127.0.0.1&sort=r&q=h1b&country=US&per_page=15&keyword=h1b<keyword_placeholder>&not=no+not%2C"
    }
    
    static var indeedURL: String {
        guard let dict = JobUtils.keys, let API_KEY = dict["INDEED_API_CLIENT_ID"] as? String else {
            return ""
        }
        return "http://api.indeed.com/ads/apisearch?publisher=\(API_KEY)&format=json&userip=127.0.0.1&filter=1&limit=15&co=us&useragent=Mozilla/5.0%20(iPhone;%20CPU%20iPhone%20OS%209_1%20like%20Mac%20OS%20X)%20AppleWebKit/601.1.46%20(KHTML,%20like%20Gecko)%20Version/9.0%20Mobile/13B143%20Safari/601.1&v=2&q=h1b"
    }
    
    static var admobAppID: String {
        guard let dict = JobUtils.keys, let APP_ID = dict["ADMOB_APP_ID"] as? String else {
            return ""
        }
        return APP_ID
    }
    
    static var admobAdUnitID: String {
        guard let dict = JobUtils.keys, let AD_UNIT_ID = dict["ADMOB_AD_UNIT_ID"] as? String else {
            return ""
        }
        return AD_UNIT_ID
    }
    
    static var testDeviceID: String {
        guard let dict = JobUtils.keys, let TEST_DEVICE_ID = dict["TEST_DEVICE_ID"] as? String else {
            return ""
        }
        return TEST_DEVICE_ID
    }
}

class JobUtils: NSObject {
    
    static var keys: [String: Any]? = {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return dict
    }()
    
    var searchTerm: String
    var jobCategory: JobCategory
    var requestURL: String {
        if searchTerm.count > 0 {
            searchTerm = searchTerm.escapedString
            switch(jobCategory) {
            case .indeed:
                return "\(AppSecrets.indeedURL)+\(searchTerm)"
            case .linkUp:
                return AppSecrets.linkUpURL.replacingOccurrences(of: "<keyword_placeholder>", with: "+\(searchTerm)")
            case .dice:
                return "\(AppSecrets.diceURL)+\(searchTerm)"
            case .careerBuilder:
                return "\(AppSecrets.careerBuilderURL)+\(searchTerm)"
            }
        } else {
            switch(jobCategory) {
            case .linkUp:
                return AppSecrets.linkUpURL.replacingOccurrences(of: "<keyword_placeholder>", with: "")
            case .indeed:
                return AppSecrets.indeedURL
            case .dice:
                return AppSecrets.diceURL
            case .careerBuilder:
                return AppSecrets.careerBuilderURL
            }
        }
    }
    
    init(category: JobCategory, search: String) {
        searchTerm = search
        jobCategory = category
    }
}
