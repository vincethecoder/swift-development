//
//  SearchResultsTableViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

protocol ResultsTableViewCellDelegate {
    func saveButtonTapped(cell: ResultsTableViewCell)
}

class ResultsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobCompany: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobPostDate: UILabel!
    @IBOutlet weak var jobCompanyLogo: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    
    var jobWebUrl: String!
    var delegate: ResultsTableViewCellDelegate?

    let likeImage = UIImage(named: "like")?.imageWithRenderingMode(.AlwaysTemplate)

    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = saveButton {
            let tap = UITapGestureRecognizer(target: self, action: Selector("saveButtonTapped:"))
            tap.cancelsTouchesInView = false
            saveButton.setImage(likeImage, forState: .Normal)
            saveButtonView.addGestureRecognizer(tap)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRectMake(15, 0, 80, 80)
        let cellImageLayer = self.imageView?.layer
        cellImageLayer?.borderWidth = 2
        cellImageLayer?.borderColor = UIColor.clearColor().CGColor
        cellImageLayer?.cornerRadius = 40
        cellImageLayer?.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        delegate?.saveButtonTapped(self)
    }
    
    @IBAction func tableRowButtonTapped(sender: AnyObject) {

    }
    
}
