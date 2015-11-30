//
//  JobsHelper.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

// Dice API Documentation: http://www.dice.com/common/content/util/apidoc/jobsearch.html

enum JobCategory: String {
    case Dice = "http://service.dice.com/api/rest/jobsearch/v1/simple.json?text=h1b,h1-b,h-1b"
    case CareerBuilder = "http://api.careerbuilder.com/v1/jobsearch?&DeveloperKey=WDTZ5LJ75JCSQBK1Z8ZX&ExcludeKeywords=%22unable%22%22cannot%22%22without%20sponsorship%22%22no%22%22Not%22%22part-time%22%22visa%20cap%20has%20been%20met%22%22unwilling%22&outputjson=true&booleanoperator=or&Keywords=h1b,h1-b,h-1b"
    case LinkUp = ""
}

class JobUtils: NSObject {
    
    var searchTerm: String
    var jobCategory: JobCategory
    var requestURL: String {
        get {
            let baseURL = jobCategory.rawValue
            if searchTerm.characters.count > 0 {
                searchTerm = searchTerm.escapedString
                return "\(baseURL),\(searchTerm)"
            } else {
                return baseURL
            }
        }
    }
    
    init(category: JobCategory, search: String) {
        searchTerm = search
        jobCategory = category
    }
}