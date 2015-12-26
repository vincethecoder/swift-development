//
//  Favorite.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import Foundation

class Favorite: NSObject {
    
    // Job Favorite Fields
    let favoriteId: Int64?
    let jobTitle: String?
    let company: String?
    let jobId: String?
    let savedTimestamp: String?
    
    init (favoriteId: Int64, jobTitle: String, company: String, jobId: String, savedTimestamp: String) {
        self.favoriteId = favoriteId
        self.jobTitle = jobTitle
        self.company = company
        self.jobId = jobId
        self.savedTimestamp = savedTimestamp
    }
}
