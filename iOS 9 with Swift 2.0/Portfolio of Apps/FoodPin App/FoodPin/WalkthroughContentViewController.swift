//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 10/5/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var forwardButton:UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        // Set the current page index
        pageControl.currentPage = index
        
        // Change the forward button's title
        switch index {
        case 0...1:
            forwardButton.setTitle("NEXT", forState: .Normal)
        case 2:
            forwardButton.setTitle("DONE", forState: .Normal)
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        switch index {
        case 0...1:
            let pageViewController = parentViewController as! WalkthroughPageViewController
            pageViewController.forward(index)
        case 2:
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "hasViewedWalkthrough")
        default:
            break
        }
    }


}
