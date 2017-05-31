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
    var build: [AnyHashable: Any]!
    
    @IBOutlet weak var webView: UIWebView!

    var addButton: UIButton {
        let button = UIButton()
        var image = "add_to_saved_icon"
        var frameHeight: CGFloat = 22
        var frameWidth: CGFloat = 22
        if let _ = job, let _ = FavoriteHelper.find(job) {
            frameWidth = 25
            frameHeight = 25
            image = "saved_job_icon"
        }
        button.setImage(UIImage(named: image), for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        button.addTarget(self, action: #selector(JobWebViewControler.userDidTapSave), for: .touchUpInside)
        return button
    }
    
    var savedButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "saved_job_icon"), for: UIControlState())
        button.tintColor = UIColor.darkGray
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(JobWebViewControler.userDidTapSave), for: .touchUpInside)
        return button
    }
    
    
    override func viewDidLoad() {
        
        if title == nil {
            self.title = "Job Description"
        }
        
        webView.scalesPageToFit = true
        
        if let url = jobUrl {
            let requestUrl = URLRequest(url: URL(string: url)!)
            // Start Activity Indicator Animation
            GMDCircleLoader.setOn(self.view, withTitle: "Loading...", animated: true)

            webView.loadRequest(requestUrl)
            webView.delegate = self
        }
    }
    
    func userDidTapSave() {
        var status = String()
        var saveImage = UIImage(named: "save_error")!

        if let jobRecord = job, let record = FavoriteHelper.find(jobRecord) {
            let success: Bool = FavoriteHelper.delete(record)
            if success == true {
                // Removed ... now animate delete icon
                status = "Removed from \nSaved Jobs"
                saveImage = UIImage(named: "delete_job")!
                
                // Set Right Bar Button item
                let rightBarButton = UIBarButtonItem()
                rightBarButton.customView = addButton
                navigationItem.rightBarButtonItem = rightBarButton
            } else {
                status = "Ooops. Delete Failed."
            }
        } else {
            // Add new record
            let favoriteId = FavoriteHelper.insert(job)

            if favoriteId != -1 {
                // Hurrray... now animate added icon
                status = "Added Job to \nSaved Jobs"
                saveImage = UIImage(named: "save_job")!
                
                // Set Right Bar Button item
                let rightBarButton = UIBarButtonItem()
                rightBarButton.customView = savedButton
                navigationItem.rightBarButtonItem = rightBarButton
            } else {
                status = "Ooops. Save Failed."
            }
        }
        
        updateFavoriteTabBadge()
        
        displaySaveView(status, image: saveImage)
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Category: Job WebView", action: "Save Job Pressed", label: "Save Job", value: nil).build() as! [AnyHashable: Any])
    }
    
    func updateFavoriteTabBadge() {
        if let _ = self.tabBarController {
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let favoriteTab = tabArray?.object(at: 1) as! UITabBarItem
            let favoriteCount = FavoriteHelper.count()
            favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
        }
    }
    
    func displaySaveView(_ status: String, image: UIImage) {
        let viewHeight: CGFloat = 158
        let viewWidth: CGFloat = 163
        let frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
        let saveView = SaveView(frame: frame, status: status, image: image)
        saveView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addSubview(saveView)
        webView.bringSubview(toFront: saveView)
        let widthConstraint = NSLayoutConstraint(item: saveView, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewWidth)
        saveView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: saveView, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewHeight)
        saveView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: saveView, attribute: .centerX, relatedBy: .equal, toItem: webView, attribute: .centerX, multiplier: 1, constant: 0)
        webView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: saveView, attribute: .centerY, relatedBy: .equal, toItem: webView, attribute: .centerY, multiplier: 1, constant: -35)
        webView.addConstraint(yCenterConstraint)
        
        UIView.animate(withDuration: 1, animations: { () -> Void in
            saveView.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                saveView.isHidden = finished
        }) 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Google Analytics
        tracker.set(kGAIScreenName, value: "/jobwebview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder?.build() as! [AnyHashable: Any])
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        GMDCircleLoader.hide(from: self.view, animated: true)
        
        // Set Right Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = addButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        GMDCircleLoader.hide(from: self.view, animated: true)
    }
}
