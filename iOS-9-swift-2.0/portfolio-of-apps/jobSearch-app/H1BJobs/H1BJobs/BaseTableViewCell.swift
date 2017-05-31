//
//  BaseTableViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func noListingsCell(_ inlineMessage: String) -> UITableViewCell {
        self.textLabel?.attributedText = NSMutableAttributedString(
            string: NSLocalizedString(inlineMessage, comment: ""),
            attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                NSForegroundColorAttributeName: UIColor.H1BTextColor()])
        self.textLabel?.numberOfLines = 0
        self.selectionStyle = .none
        self.accessoryType = .none
        return self
    }

}
