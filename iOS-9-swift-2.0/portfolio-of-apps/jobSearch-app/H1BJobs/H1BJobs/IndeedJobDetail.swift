//
//  IndeedJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/18/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import Foundation

struct IndeedJobDetail {
    
    var jobtitle: String?
    var company: String?
    var city: String?
    var state: String?
    var country: String?
    var formattedLocation: String?
    var source: String?
    var date: String?
    var datePosted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        guard let dateString = date else {
            return Date()
        }
        let formattedDate = dateFormatter.date(from: dateString) ?? Date()
        return formattedDate
    }
    var snippet: String?
    var url: String?
    var jobkey: String?
    var formattedLocationFull: String?
    var sponsored: NSNumber?
    var expired: NSNumber?
    var indeedApply: NSNumber?
    var formattedRelativeTime: String?
    var onmousedown: String?
    var stations: String?
    var language: String?
    
    init(dict: [String: AnyObject]) {
        if let title = dict["jobtitle"] as? String {
            jobtitle = title
        }
        
        if let _company = dict["company"] as? String {
            company = _company
        }
        
        if let _city = dict["city"] as? String {
            city = _city
        }
        
        if let _state = dict["state"] as? String {
            state = _state
        }
        
        if let _country = dict["country"] as? String {
            country = _country
        }
        
        if let _location = dict["formattedLocation"] as? String {
            formattedLocation = _location
        }
        
        if let _sponsored = dict["sponsored"] as? NSNumber {
            sponsored = _sponsored
        }
        
        if let _expired = dict["expired"] as? NSNumber {
            expired = _expired
        }
        
        if let _apply = dict["indeedApply"] as? NSNumber {
            indeedApply = _apply
        }
        
        if let _relativeTime = dict["formattedRelativeTime"] as? String {
            formattedRelativeTime = _relativeTime
        }
        
        if let _onmousedown = dict["onmousedown"] as? String {
            onmousedown = _onmousedown
        }
        
        if let _stations = dict["stations"] as? String {
            stations = _stations
        }
        
        if let _language = dict["language"] as? String {
            language = _language
        }
        
        if let _date = dict["date"] as? String {
            date = _date
        }
    }

}
