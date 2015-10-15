//
//  Restaurant.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/28/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var phoneNumber = ""
    var image = ""
    var phone = ""
    var isVisited = false
    
    init(name:String, type:String, location:String, phoneNumber:String, image:String, isVisited:Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phoneNumber = phoneNumber
        self.image = image
        self.isVisited = isVisited
    }
}
