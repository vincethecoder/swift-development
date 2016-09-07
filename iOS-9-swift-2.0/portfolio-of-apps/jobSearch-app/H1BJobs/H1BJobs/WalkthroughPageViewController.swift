//
//  WalkthroughPageViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/15/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pages: [WalkthroughPage] = [
        WalkthroughPage(heading: "Revamping \nH1B Job Search", content: "Discover all US Jobs Capable & Willing to Sponsor your Work Visa."),
        WalkthroughPage(heading: "Real-Time \nSearch Results", content: "Review & Select from a variety of job openings from Dice, CareerBuilder, Indeed & LinkUp."),
        WalkthroughPage(heading: "Re-Filtered \nSearch Results", content: "H1B Jobs acknowledges your interest in Visa Sponsored Jobs and fine-tunes listings to meet your search keywords."),
        WalkthroughPage(heading: "Begin Search", content: "Several H1B, Green Card, OPT and CPT Jobs are just a tap away!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= pages.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.heading = pages[index].heading
            pageContentViewController.content = pages[index].content
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    func forward(index:Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
}
