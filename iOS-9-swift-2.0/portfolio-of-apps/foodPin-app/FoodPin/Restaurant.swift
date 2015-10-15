//
//  Restaurant.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/28/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {
    @NSManaged var name:String
    @NSManaged var type:String
    @NSManaged var location:String
    @NSManaged var phoneNumber:String?
    @NSManaged var image:NSData?
    @NSManaged var isVisited:NSNumber?
    @NSManaged var rating:String?
    
//    init(name:String, type:String, location:String, phoneNumber:String, image:String, isVisited:Bool) {
//        self.name = name
//        self.type = type
//        self.location = location
//        self.phoneNumber = phoneNumber
//        self.image = image
//        self.isVisited = isVisited
//    }
}

