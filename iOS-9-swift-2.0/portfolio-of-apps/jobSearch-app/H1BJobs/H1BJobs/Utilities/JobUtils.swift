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
    case Dice = "http://service.dice.com/api/rest/jobsearch/v1/simple.json?text=h1b,h1-b,h-1b"
    case CareerBuilder = "http://api.careerbuilder.com/v1/jobsearch?&DeveloperKey=WDTZ5LJ75JCSQBK1Z8ZX&ExcludeKeywords=%22unable%22%22cannot%22%22without%20sponsorship%22%22no%22%22Not%22%22part-time%22%22visa%20cap%20has%20been%20met%22%22unwilling%22&outputjson=true&booleanoperator=or&Keywords=h1b,h1-b,h-1b"
    case LinkUp = "http://www.linkup.com/developers/v-1/search-handler.js?api_key=76C53BDC6854D5939505307A74337BC4&embedded_search_key=b06efca40addeb05131bef527b196953&orig_ip=127.0.0.1&sort=r&q=h1b&country=US&per_page=15&keyword=h1b<keyword_placeholder>&not=no+not%2C"
    case Indeed = "http://api.indeed.com/ads/apisearch?publisher=5572911862581719&format=json&userip=127.0.0.1&filter=1&limit=15&co=us&useragent=Mozilla/5.0%20(iPhone;%20CPU%20iPhone%20OS%209_1%20like%20Mac%20OS%20X)%20AppleWebKit/601.1.46%20(KHTML,%20like%20Gecko)%20Version/9.0%20Mobile/13B143%20Safari/601.1&v=2&q=h1b"
}

class JobUtils: NSObject {
    
    var searchTerm: String
    var jobCategory: JobCategory
    var requestURL: String {
        get {
            let baseURL = jobCategory.rawValue
            if searchTerm.characters.count > 0 {
                searchTerm = searchTerm.escapedString
                if jobCategory == .Indeed {
                    return "\(baseURL)+\(searchTerm)"
                } else if jobCategory == .LinkUp {
                    return baseURL.stringByReplacingOccurrencesOfString("<keyword_placeholder>", withString: "+\(searchTerm)")
                }
                return "\(baseURL),\(searchTerm)"
            } else {
                if jobCategory == .LinkUp {
                    return baseURL.stringByReplacingOccurrencesOfString("<keyword_placeholder>", withString: "")
                }
                return baseURL
            }
        }
    }
    
    init(category: JobCategory, search: String) {
        searchTerm = search
        jobCategory = category
    }
}