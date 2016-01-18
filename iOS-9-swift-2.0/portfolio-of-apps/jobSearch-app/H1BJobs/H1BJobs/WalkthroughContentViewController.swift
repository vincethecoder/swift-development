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

        filterView.backgroundColor = .blackColor()
        filterView.alpha = 0.75
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var imageName = String()
        switch(index) {
        case 0: imageName = "revamp-search"
        case 1: imageName = "realtime-job-search"
        case 2: imageName = "filtered-job-search"
        case 3: imageName = "begin-job-search"
        default:
            break
        }
        
        if imageName.characters.count > 0 {
            bgImageView.image = UIImage(named: imageName)
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
