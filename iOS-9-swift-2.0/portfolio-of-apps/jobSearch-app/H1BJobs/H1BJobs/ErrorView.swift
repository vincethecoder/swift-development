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
        
        let newView = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as! ErrorView
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newView)
        
        let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthConstraint = newView.widthAnchor.constraint(equalToConstant: frame.width)
        let heightConstraint = newView.heightAnchor.constraint(equalToConstant: frame.height)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        newView.errorText.text = text
        newView.errorTitle.text = title
        newView.errorImageView.image = image
        
        newView.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
