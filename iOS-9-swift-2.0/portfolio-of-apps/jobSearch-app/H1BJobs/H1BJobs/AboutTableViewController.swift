//
//  AboutTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/10/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    @IBOutlet weak var bannerContainer: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    var sectionContent = [ ["Rate App on iTunes", "Contact Developer"],
                           ["LinkedIn", "Github", "Twitter", "Google+"] ]

    let webViewSegueIdentifier = "showWebView"
    
    var socialMedia = [
        JobSocialMedia.init(name: "LinkedIn",
                            url: "https://www.linkedin.com/in/vincentsam",
                            image: UIImage(named: "linkedIn_icon_small")!),
        JobSocialMedia.init(name: "Github",
                            url: "https://github.com/vincethecoder",
                            image: UIImage(named: "github_icon_small")!),
        JobSocialMedia.init(name: "Twitter",
                            url: "https://twitter.com/vincethecoder",
                            image: UIImage(named: "twitter_icon_small")!),
        JobSocialMedia.init(name: "Google+",
                            url: "https://plus.google.com/u/0/107574104106439596127/about",
                            image: UIImage(named: "google_icon_small")!)
    ]
    
    enum AboutTableSection : Int {
        case ImageSection = 0
        case OtherSection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search Results Page Title
        title = "About"
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        
        // Apply a blurring effect to the background image view
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width * 2, view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
        
        formatLogoImageView()
        
        let translate = CGAffineTransformMakeTranslation(250, 0)
        logoImageView.transform = translate
    }
    
    func formatLogoImageView() {
        logoImageView.layer.borderWidth = 1.0
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.H1BBorderColor().CGColor
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
        logoImageView.clipsToBounds = true
    }

    override func viewDidAppear(animated: Bool) {
        // Normal animation
        UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: {
            self.logoImageView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AboutTableSection(rawValue: section) == .ImageSection {
            return 2
        } else {
            return socialMedia.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.backgroundColor = .clearColor()
        
        if indexPath.section == AboutTableSection.OtherSection.rawValue {
            let record = socialMedia[indexPath.row]
            cell.textLabel?.text = record.name
            cell.imageView?.image = record.image
            cell.accessoryType = .DisclosureIndicator    
        } else {
            cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == webViewSegueIdentifier, let indexPath = tableView.indexPathForSelectedRow {
            let webView = segue.destinationViewController as? JobWebViewControler
            let record = socialMedia[indexPath.row]
            webView?.title = "Contact via - \(record.name)"
            webView?.jobUrl = record.url
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {

        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: tableView)
        
        if let indexPath = tableView.indexPathForRowAtPoint(rootViewPoint!) where indexPath.section == AboutTableSection.ImageSection.rawValue {
            if indexPath.row == 0 { // Rate App
                let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/")
                UIApplication.sharedApplication().openURL(url!)
            } else { // Contact Developer
                //  TODO: Email me ...
            }
            return false
        }
        return true
    }

}
