//
//  History.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/20/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class History: NSObject {
    
    // Search History Fields
    let searchId: Int64?
    let keyword: String?
    let location: String?
    let state: String?
    let timestamp: String?
    
    init (searchId: Int64, keyword: String, location: String, state: String, timestamp: String) {
        self.searchId = searchId
        self.keyword = keyword
        self.location = location
        self.state = state
        self.timestamp = timestamp
    }
    
    override init() {
        self.searchId = Int64()
        self.keyword = String()
        self.location = String()
        self.state = String()
        self.timestamp = String()
    }
}