//
//  HistoryTableViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/15/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var jobKeyword: UILabel!
    @IBOutlet weak var jobSearchDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
