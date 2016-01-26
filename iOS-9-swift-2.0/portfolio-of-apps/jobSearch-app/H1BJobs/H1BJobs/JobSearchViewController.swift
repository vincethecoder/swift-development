//
//  JobSearchViewController.swift
//  H1BJobs
//
//  Created by Vincent Sam on 10/26/15.
//  Copyright © 2015 Vincent Sam. All rights reserved.
//

import UIKit

class JobSearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let resultsSegueIdentifier = "showResults"
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    
    var build: [NSObject: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let keywordPlaceholder = "Job title or keywords"
        formatTextField(keywordsTextField, text: keywordPlaceholder)
        formatButton(searchButton, text: "Search")
        formatLogoImageView()

        let font = UIFont(name: "Avenir", size: 18)!
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: font]
        keywordsTextField.attributedPlaceholder = NSAttributedString(string: keywordPlaceholder, attributes:attributes)
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        logoImageView.transform = CGAffineTransformConcat(scale, translate)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        keywordsTextField.delegate = self
        
        view.backgroundColor = UIColor.H1BHeaderColor()
        view.alpha = 0.98
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: {
            self.logoImageView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        guard hasViewedWalkthrough == false else { return }
        
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateFavoriteTabBadge()
        
        // Google Analytics
        tracker.set(kGAIScreenName, value: "/searchview")
        let builder = GAIDictionaryBuilder.createScreenView()
        build = builder.build() as [NSObject: AnyObject]
        tracker.send(build)
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray.objectAtIndex(1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }
    
    func formatLogoImageView() {
        logoImageView.layer.borderWidth = 1.0
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.H1BBorderColor().CGColor
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
        logoImageView.clipsToBounds = true
    }

    func blurBackgroundEffect() {
        // Apply a blurring effect to the background image view
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func formatTextField(textField: UITextField, text: String) {
        textField.attributedPlaceholder = NSAttributedString(string:text,
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        textField.borderStyle = .RoundedRect
        textField.backgroundColor = UIColor.whiteColor()

        textField.leftViewMode = .Always
        textField.leftView = UIImageView(image: UIImage(named: "action_search"))
        
        textField.autocorrectionType = .Yes
    }
    
    func formatButton(button: UIButton, text: String) {
        button.setTitle(text, forState: .Normal)

        button.layer.cornerRadius = 8.0
        button.layer.borderColor = UIColor.H1BBorderColor().CGColor
        button.layer.borderWidth = 1.0

        button.layer.backgroundColor = UIColor.H1BHeaderColor().CGColor
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        let keywords = keywordsTextField.text!
        let historyRecord = History(searchId: 0, keyword: keywords, location: "", state: "", timestamp: NSDate())
        let historyId = HistoryHelper.insert(historyRecord)
        print("history id \(historyId)")
        

        var keywordProcessed = String()
        var keywordCategory = String()

        if keywords.characters.count > 0 {
            keywordProcessed = "\(keywords)"
            keywordCategory = "custom search"
        } else {
            keywordProcessed = "Any H1B Job"
            keywordCategory = "default search"
        }
        
        // Google Analytics
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Keyword: \(keywordProcessed)", action: "Search Pressed", label: keywordCategory, value: nil).build() as [NSObject : AnyObject])
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == resultsSegueIdentifier {
            let searchResults = segue.destinationViewController as? SearchResultsViewController
            searchResults?.keywords = keywordsTextField.text
        }
    }

}
