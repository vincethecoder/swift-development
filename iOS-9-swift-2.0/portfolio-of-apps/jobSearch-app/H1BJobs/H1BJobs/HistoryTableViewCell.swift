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
    @IBOutlet weak var jobSearchDate: UILabel!
    @IBOutlet weak var jobSearchDateMonth: UILabel!
    @IBOutlet weak var jobSearchDateDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
