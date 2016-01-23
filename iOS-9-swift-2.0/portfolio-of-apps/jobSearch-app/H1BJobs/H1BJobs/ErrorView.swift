//
//  ErrorView.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/23/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit
import Foundation

class ErrorView: UIView {

    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorText: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()  
    }
    
    init(frame: CGRect, title: String, text: String, image: UIImage) {
        super.init(frame: frame)
        
        let newView = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil).first as! ErrorView
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newView)
        let horizontalConstraint = newView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        let widthConstraint = newView.widthAnchor.constraintEqualToAnchor(nil, constant: frame.width)
        let heightConstraint = newView.heightAnchor.constraintEqualToAnchor(nil, constant: frame.height)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        newView.errorText.text = text
        newView.errorTitle.text = title
        newView.errorImageView.image = image
        
        newView.backgroundColor = .clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
