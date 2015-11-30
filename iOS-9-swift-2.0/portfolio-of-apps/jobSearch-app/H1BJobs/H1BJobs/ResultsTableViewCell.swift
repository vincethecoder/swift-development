//
//  SearchResultsTableViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobCompany: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobPostDate: UILabel!
    @IBOutlet weak var jobSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
