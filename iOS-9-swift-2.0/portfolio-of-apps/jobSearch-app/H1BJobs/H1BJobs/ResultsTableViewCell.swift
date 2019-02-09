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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonView: UIView!
    
    var jobWebUrl: String!
    var delegate: ResultsTableViewCellDelegate?

    let likeImage = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)

    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = saveButton {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.saveButtonTapped(_:)))
            tap.cancelsTouchesInView = false
            saveButton.setImage(likeImage, for: .normal)
            saveButtonView.addGestureRecognizer(tap)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 0, width: 80, height: 80)
        let cellImageLayer = self.imageView?.layer
        cellImageLayer?.borderWidth = 2
        cellImageLayer?.borderColor = UIColor.clear.cgColor
        cellImageLayer?.cornerRadius = 40
        cellImageLayer?.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.saveButtonTapped(cell: self)
    }
    
    @IBAction func tableRowButtonTapped(_ sender: Any) {

    }
    
}
