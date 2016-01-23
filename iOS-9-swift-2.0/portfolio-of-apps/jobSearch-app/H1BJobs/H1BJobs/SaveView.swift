//
//  SaveView.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/23/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

class SaveView: UIView {

    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var saveStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(frame: CGRect, status: String, image: UIImage) {
        super.init(frame: frame)
        
        let newView = NSBundle.mainBundle().loadNibNamed("SaveView", owner: self, options: nil).first as! SaveView
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newView)
        
        let horizontalConstraint = newView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        let widthConstraint = newView.widthAnchor.constraintEqualToAnchor(nil, constant: frame.width)
        let heightConstraint = newView.heightAnchor.constraintEqualToAnchor(nil, constant: frame.height)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        newView.saveImageView.image = image
        newView.saveStatusLabel.text = status
        newView.layer.cornerRadius = 15

        newView.backgroundColor = .blackColor()
        newView.alpha = 0.95
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
