//
//  Dice.swift
//  H1BJobs
//
//  Created by Vincent Sam on 11/22/15.
//  Copyright © 2015 Vincent Sam. All rights reserved.
//

import UIKit

class DiceJob: NSObject {

    var nextUrl: String = ""
    var count: Int = 0
    var firstDocument: Int = 0
    var lastDocument: Int = 0
    var jobListings: [DiceJobDetail] = []
    
    var resultItemList:[AnyObject] = [AnyObject]() {
        didSet {
            for items in resultItemList {
                let item = items as! [String : AnyObject]
                let jobItem: DiceJobDetail = DiceJobDetail.init(dict: item)
                jobListings.append(jobItem)
            }
        }
    }
    
    var hasResults: Bool {
        return resultItemList.count > 0
    }
    
    var hasNextPage: Bool {
        return nextUrl.count > 0
    }
    
    var jobData = [String: AnyObject]() {
        didSet {
            self.setValuesForKeys(jobData)
        }
    }

}
