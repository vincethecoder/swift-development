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

        filterView.backgroundColor = UIColor.H1BHeaderColor
        filterView.alpha = 0.65
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var imageName = String()
        var iconName = String()

        switch(index) {
            case 0:
                imageName = "1-revamp-passport"
                iconName = "microscope_image"
                getStartedLabel.text = "GET STARTED"
            case 1:
                imageName = "2-real-time"
                iconName = "real_time_image"
                getStartedLabel.text = "GET STARTED"
            case 2:
                imageName = "3-filtered-job-search"
                iconName = "filter_filled_image"
                getStartedLabel.text = "GET STARTED"
            case 3:
                imageName = "4-begin-search"
                iconName = "begin_search_image"
                getStartedLabel.text = "I'M READY"
            default:
                break
        }
        
        if let bgImage = UIImage(named: imageName) {
            bgImageView.image = bgImage
        }
        
        if let iconImage = UIImage(named: iconName) {
            iconImageView.image = iconImage
        }
        
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        switch index {
        case 0...2:
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.forward(index: index)
        case 3:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
