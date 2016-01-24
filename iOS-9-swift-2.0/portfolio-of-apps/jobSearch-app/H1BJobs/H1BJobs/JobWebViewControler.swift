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
    var job: Favorite!
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    var build: [NSObject: AnyObject]!
    
    @IBOutlet weak var webView: UIWebView!

    var saveButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "add_job_action"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 25, 25)
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
        }
    }
    
    func userDidTapSave() {
        //Implementation goes here ...
        var status = String()
        var saveImage = UIImage(named: "save_error")!
        
        let jobRecord = job
        if let record = FavoriteHelper.find(jobRecord) {
            let success: Bool = FavoriteHelper.delete(record)
            if success == true {
                // Removed ... now animate delete icon
                status = "Removed from \nSaved List"
                saveImage = UIImage(named: "delete_job")!
            } else {
                status = "Ooops. Delete Failed."
            }
        } else {
            // Add new record
            let favoriteId = FavoriteHelper.insert(jobRecord)
            print("favorite id \(favoriteId)")
            
            if favoriteId != -1 {
                // Hurrray... now animate added icon
                status = "Added Job to \nSaved List"
                saveImage = UIImage(named: "save_job")!
            } else {
                status = "Ooops. Save Failed."
            }
        }
        
        displaySaveView(status, image: saveImage)
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Category: Job WebView", action: "Save Job Pressed", label: "Save Job", value: nil).build() as [NSObject : AnyObject])
    }
    
    func displaySaveView(status: String, image: UIImage) {
        let viewHeight: CGFloat = 158
        let viewWidth: CGFloat = 163
        let frame = CGRectMake(0, 0, viewWidth, viewHeight)
        
        let saveView = SaveView(frame: frame, status: status, image: image)
        saveView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addSubview(saveView)
        webView.bringSubviewToFront(saveView)
        let widthConstraint = NSLayoutConstraint(item: saveView, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewWidth)
        saveView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: saveView, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        saveView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: saveView, attribute: .CenterX, relatedBy: .Equal, toItem: webView, attribute: .CenterX, multiplier: 1, constant: 0)
        webView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: saveView, attribute: .CenterY, relatedBy: .Equal, toItem: webView, attribute: .CenterY, multiplier: 1, constant: -35)
        webView.addConstraint(yCenterConstraint)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            saveView.alpha = 0
            }) { (finished: Bool) -> Void in
                saveView.hidden = finished
        }
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
        
        // Set Right Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = saveButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        GMDCircleLoader.hideFromView(self.view, animated: true)
    }
}
