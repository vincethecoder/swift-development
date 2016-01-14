//
//  HistoryTableViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/15/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class HistoryTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var jobKeyword: UILabel!
    @IBOutlet weak var jobSearchDateMonth: UILabel!
    @IBOutlet weak var jobSearchDateDay: UILabel!
    @IBOutlet weak var calendarContainer: UIView!
    
    @IBOutlet weak var historySearchIcon: UIImageView!
    @IBOutlet weak var historyLocationIcon: UIImageView!
    @IBOutlet weak var historyLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        calendarContainer.layer.borderWidth = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
