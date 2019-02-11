//
//  Dice.swift
//  H1BJobs
//
//  Created by Vincent Sam on 11/22/15.
//  Copyright © 2015 Vincent Sam. All rights reserved.
//

import UIKit

class DiceJob: NSObject {
    
    var jobListings: [DiceJobDetail] = []
    
    var jobData = [String: AnyObject]() {
        didSet {
            let diceJobDetail = DiceJobDetail(dict: jobData)
            jobListings.append(diceJobDetail)
        }
    }

}
