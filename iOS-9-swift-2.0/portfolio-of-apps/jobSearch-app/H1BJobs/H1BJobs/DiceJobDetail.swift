//
//  DiceJobDetail.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class DiceJobDetail: NSObject {

    var detailUrl: String?
    var jobTitle: String?
    var company: String?
    var location: String?
    var postdate: Date?
    var date: String? {
        didSet {
            postdate = date!.diceJobPostDateDayMonthYear()
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
}
