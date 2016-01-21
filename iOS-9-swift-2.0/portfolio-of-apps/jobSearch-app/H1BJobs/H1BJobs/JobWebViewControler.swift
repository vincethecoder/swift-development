//
//  JobWebViewControler.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/3/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

class JobWebViewControler: UIViewController, UIWebViewDelegate {

    var jobUrl: String?
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    var build: [NSObject: AnyObject]!
    
    @IBOutlet weak var webView: UIWebView!
    
    var defaultSaveButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: ""), forState: .Normal)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.addTarget(self, action: Selector("userDidTapSave"), forControlEvents: .TouchUpInside)
        return button
    }

    var saveButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "red_like_filled"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.addTarget(self, action: Selector("userDidTapSave"), forControlEvents: .TouchUpInside)
        return button
    }
    
    
    override func viewDidLoad() {
        
        if title == nil {
            self.title = "H1B Job - Apply"
        }
        
        webView.scalesPageToFit = true
        
        if let url = jobUrl {
            let requestUrl = NSURLRequest(URL: NSURL(string: url)!)
            // Start Activity Indicator Animation
            GMDCircleLoader.setOnView(self.view, withTitle: "Loading...", animated: true)

            webView.loadRequest(requestUrl)
            webView.delegate = self
            
            // Set Right Bar Button item
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = saveButton
            navigationItem.rightBarButtonItem = rightBarButton
            
        }
    }
    
    
    func userDidTapSave() {
        //Implementation goes here ...
        
        if navigationItem.rightBarButtonItem == defaultSaveButton {
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = saveButton
            navigationItem.rightBarButtonItem = rightBarButton
        }
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Category: Job WebView", action: "Save Job Pressed", label: "Save Job", value: nil).build() as [NSObject : AnyObject])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Google Analytics
        tracker.set(kGAIScreenName, value: "/jobwebview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        GMDCircleLoader.hideFromView(self.view, animated: true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        GMDCircleLoader.hideFromView(self.view, animated: true)
    }
}
