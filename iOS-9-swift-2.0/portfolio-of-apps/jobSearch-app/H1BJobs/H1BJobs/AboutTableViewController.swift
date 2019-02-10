//
//  AboutTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/10/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit
import MessageUI

@available(iOS 10.0, *)
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
    
    var socialMedia = [JobSocialMedia]()
    
    enum AboutTableSection : Int {
        case ImageSection = 0
        case OtherSection
    }
    
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    
    var build: [NSObject: AnyObject]!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search Results Page Title
        title = "About"
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        
        // Apply a blurring effect to the background image view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
        
        //formatLogoImageView()
        
        let translate = CGAffineTransform(translationX: 250, y: 0)
        logoImageView.transform = translate
        
        // Google Analytics
        tracker.set(kGAIScreenName, value: "/aboutview")
        let builder = GAIDictionaryBuilder.createScreenView()
        if let build = builder?.build() {
            tracker.send(build as [NSObject: AnyObject] )
        }
        
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "upload-50"), for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(self.userDidTapShare(_:)), for: .touchUpInside)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "/appinfoview")
        let builder = GAIDictionaryBuilder.createScreenView()
        if let build = builder?.build() {
            tracker?.send(build as [NSObject : AnyObject])
        }
    }

    func formatImageView(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = imageView == logoImageView ? UIColor.H1BBorderColor.cgColor : UIColor.clear.cgColor
        imageView.layer.cornerRadius = imageView.frame.width / (imageView != logoImageView ? 2 : 5)
        imageView.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Normal animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.logoImageView.transform = .identity
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AboutTableSection(rawValue: section) == .ImageSection {
            return 2
        } else {
            return socialMedia.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = .clear
        
        if indexPath.section == AboutTableSection.OtherSection.rawValue {
            // TODO:
        } else {
            cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "star-25")
            } else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(named: "report_issue_icon")
            }
            cell.accessoryType = .none
        }
        
        return cell
    }

    @objc func userDidTapShare(_ button: UIButton) {
        //Implementation goes here ...
        // @TODO: Link maker: https://linkmaker.itunes.apple.com/en-us/?
        let message = "Just found tons of visa-sponsored jobs on the FREE \"H1B Jobs\" mobile app. Hurry, download your copy now!! http://apple.co/1Ki9z7C"
        let screencapture = UIImage(named: "share_h1b_jobs")
        let dataToShare: [AnyObject] = [message as AnyObject, screencapture!]
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        if activityViewController.responds(to: #selector(getter: popoverPresentationController)) {
            activityViewController.popoverPresentationController?.sourceView = button;
        }
        self.present(activityViewController, animated: true, completion: nil)
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Category: Share App", action: "Share App Pressed", label: "Share App", value: nil).build() as [NSObject : AnyObject])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let indexPath = tableView.indexPathForSelectedRow, indexPath.section == AboutTableSection.ImageSection.rawValue {
            
            var category: String?
            if indexPath.row == 0 { // Rate App
                if let url  = URL(string: "itms-apps://itunes.apple.com/app/id1078044924"), UIApplication.shared.canOpenURL(url) {
                    category = "Rate App"
                    UIApplication.shared.open(url, options: [:])
                }
                
            } else { // Contact Developer
                category = "Contact Developer"
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
            }
            
            if let category = category {
                // Google Analytics
                tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Category: \(category)", action: "\(category) cell tapped", label: category, value: nil).build() as [NSObject : AnyObject])
            }
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
        let alert = UIAlertController(title: "Could Not Send Email", message:"Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
