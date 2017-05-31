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
        
        let newView = Bundle.main.loadNibNamed("SaveView", owner: self, options: nil)?.first as! SaveView
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newView)
        
        let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthConstraint = newView.widthAnchor.constraint(equalToConstant: frame.width)
        let heightConstraint = newView.heightAnchor.constraint(equalToConstant: frame.height)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        newView.saveImageView.image = image
        newView.saveStatusLabel.text = status
        newView.layer.cornerRadius = 15

        newView.backgroundColor = .black
        newView.alpha = 0.95
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
