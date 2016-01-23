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
    @IBOutlet weak var historySearchIcon: UIImageView!
    @IBOutlet weak var historyLocationIcon: UIImageView!
    @IBOutlet weak var historyLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRectMake(20, 3, 50, 50)
        let cellImageLayer = self.imageView?.layer
        cellImageLayer?.borderWidth = 2
        cellImageLayer?.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
