//
//  FavoriteDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import Foundation

class FavoriteDetail: NSObject {
    
    let favoriteId: Int64?
    let jobId: String?
    let jobLocation: String?
    let locationLat: String?
    let locationLng: String?
    let descTeaser: String?
    let pay: String?
    let postDate: String?
    let imageUrl: String?


    init (favoriteId: Int64, jobId: String, jobLocation: String?, locationLat: String, locationLng: String, descTeaser: String, pay: String, postDate: String, imageUrl: String) {
        self.favoriteId = favoriteId
        self.jobId = jobId
        self.jobLocation = jobLocation
        self.locationLat = locationLat
        self.locationLng = locationLng
        self.descTeaser = descTeaser
        self.pay = pay
        self.postDate = postDate
        self.imageUrl = imageUrl
    }
}