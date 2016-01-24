//
//  AboutTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/10/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit
import MessageUI

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var bannerContainer: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var diceImageView: UIImageView!
    @IBOutlet weak var cbImageView: UIImageView!
    @IBOutlet weak var indeedImageView: UIImageView!
    @IBOutlet weak var linkUpImageView: UIImageView!

    var sectionContent = [ ["Write a Review", "Report an Issue"],
                           ["LinkedIn", "Github", "Twitter", "Google+"] ]

    let webViewSegueIdentifier = "showWebView"
    
    var socialMedia = []
    
    enum AboutTableSection : Int {
        case ImageSection = 0
        case OtherSection
    }
    
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    
    var build: [NSObject: AnyObject]!
    
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
        
        //formatLogoImageView()
        
        let translate = CGAffineTransformMakeTranslation(250, 0)
        logoImageView.transform = translate
        
        // Google Analytics
        tracker.set(kGAIScreenName, value: "/aboutview")
        let builder = GAIDictionaryBuilder.createScreenView()
        build = builder.build() as [NSObject: AnyObject]
        tracker.send(build)
        
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "upload-50"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("userDidTapShare"), forControlEvents: .TouchUpInside)
        
        // Set Right Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        navigationItem.rightBarButtonItem = rightBarButton
        
        formatImageView(diceImageView)
        formatImageView(cbImageView)
        formatImageView(indeedImageView)
        formatImageView(linkUpImageView)
        formatImageView(logoImageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "/appinfoview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    func formatImageView(imageView: UIImageView) {
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = imageView == logoImageView ? UIColor.H1BBorderColor().CGColor : UIColor.clearColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.width / (imageView != logoImageView ? 2 : 5)
        imageView.clipsToBounds = true
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
            // TODO:
        } else {
            cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "star-25")
            } else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(named: "report_issue_icon")
            }
            cell.accessoryType = .None
        }
        
        return cell
    }

    func userDidTapShare() {
        //Implementation goes here ...
        let message = "I just found tons of visa-sponsored jobs on the FREE \"H1B Jobs\" mobile app. Hurry, download your copy now!!"
        let screencapture = UIImage(named: "share_h1b_jobs")
        let dataToShare: [AnyObject] = [message, screencapture!]
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Category: Share App", action: "Share App Pressed", label: "Share App", value: nil).build() as [NSObject : AnyObject])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {

        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: tableView)
        
        if let indexPath = tableView.indexPathForRowAtPoint(rootViewPoint!) where indexPath.section == AboutTableSection.ImageSection.rawValue {
            
            var category = String()
            if indexPath.row == 0 { // Rate App
                let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/")
                UIApplication.sharedApplication().openURL(url!)
                category = "Rate App"
            } else { // Contact Developer
                category = "Contact Developer"
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
            
            // Google Analytics
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Category: \(category)", action: "\(category) cell tapped", label: category, value: nil).build() as [NSObject : AnyObject])
            return false
        }
        return true
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["vincent.k.sam@gmail.com"])
        mailComposerVC.setSubject("H1B Jobs Issue")
        mailComposerVC.setMessageBody("Hi Sam, \n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message:"Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        presentViewController(alert, animated: true){}
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
