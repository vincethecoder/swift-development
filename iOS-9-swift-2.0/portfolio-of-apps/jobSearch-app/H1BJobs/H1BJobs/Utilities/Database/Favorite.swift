//
//  Favorite.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class Favorite: NSObject {
    
    // Job Favorite Fields
    let favoriteId: Int64!
    let jobTitle: String!
    let company: String!
    let jobUrl: String!
    let savedTimestamp: String!
    let image: NSData!
    
    init (favoriteId: Int64, jobTitle: String, company: String, jobUrl: String,  savedTimestamp: String, image: NSData) {
        self.favoriteId = favoriteId
        self.jobTitle = jobTitle
        self.company = company
        self.jobUrl = jobUrl
        self.savedTimestamp = savedTimestamp
        self.image = image
    }
    
    override init() {
        self.favoriteId = Int64()
        self.jobTitle = String()
        self.company = String()
        self.jobUrl = String()
        self.savedTimestamp = String()
        self.image = NSData()
    }
}
