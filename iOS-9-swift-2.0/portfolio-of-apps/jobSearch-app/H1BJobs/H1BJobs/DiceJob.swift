//
//  Dice.swift
//  H1BJobs
//
//  Created by Vincent Sam on 11/22/15.
//  Copyright © 2015 Vincent Sam. All rights reserved.
//

import UIKit

class DiceJob: NSObject {

    var nextUrl = ""
    var count = 0
    var firstDocument = 0
    var lastDocument = 0
    var jobListings = [DiceJobDetail]()
    
    var resultItemList:[AnyObject] = [AnyObject]() {
        didSet {
            for items in resultItemList {
                if let item = items as? [String : Any] {
                    let jobItem: DiceJobDetail = DiceJobDetail(dict: item)
                    jobListings.append(jobItem)
                }
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
