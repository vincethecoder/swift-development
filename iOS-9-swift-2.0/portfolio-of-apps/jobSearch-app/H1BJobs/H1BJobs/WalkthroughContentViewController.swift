//
//  WalkthroughContentViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/15/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var forwardButton:UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var getStartedLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var index = 0
    var heading: String!
    var image: UIImage!
    var content: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        contentLabel.text = content
        
        // Set the current page index
        pageControl.currentPage = index

        filterView.backgroundColor = UIColor.H1BHeaderColor()
        filterView.alpha = 0.65
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var imageName = String()
        var iconName = String()

        switch(index) {
            case 0:
                imageName = "revamp-search"
                iconName = "microscope_image"
            case 1:
                imageName = "realtime-job-search"
                iconName = "real_time_image"
            case 2:
                imageName = "filtered-job-search"
                iconName = "filter_filled_image"
            case 3:
                imageName = "begin-job-search"
                iconName = "begin_search_image"
                getStartedLabel.text = "I'M DONE"
            default:
                break
        }
        
        if imageName.characters.count > 0 {
            bgImageView.image = UIImage(named: imageName)
        }
        
        if iconName.characters.count > 0 {
            iconImageView.image = UIImage(named: iconName)
        }
        
    }

    @IBAction func nextButtonTapped(sender: UIButton) {
        
        switch index {
        case 0...2:
            let pageViewController = parentViewController as! WalkthroughPageViewController
            pageViewController.forward(index)
        case 3:
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "hasViewedWalkthrough")
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
}
