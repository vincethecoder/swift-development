//
//  ResultsCollectionViewCell.swift
//  H1BJobs
//
//  Created by Kobe Sam on 2/7/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

protocol ResultsCollectionViewCellDelegate {
    func saveButtonTapped(cell: ResultsCollectionViewCell)
}

class ResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobCompany: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var jobPostDate: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var jobWebUrl: String!
    var delegate: ResultsCollectionViewCellDelegate?
    
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
        let cellImageLayer = self.imageView?.layer
        cellImageLayer?.borderWidth = 2
        cellImageLayer?.borderColor = UIColor.clearColor().CGColor
        cellImageLayer?.cornerRadius = 40
        cellImageLayer?.masksToBounds = true
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 5
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        delegate?.saveButtonTapped(self)
    }
    
    @IBAction func collectionCellTapped(sender: AnyObject) {
        
    }
    
}
