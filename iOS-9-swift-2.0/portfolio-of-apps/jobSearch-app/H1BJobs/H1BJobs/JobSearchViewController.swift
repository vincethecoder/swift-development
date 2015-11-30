//
//  JobSearchViewController.swift
//  H1BJobs
//
//  Created by Vincent Sam on 10/26/15.
//  Copyright © 2015 Vincent Sam. All rights reserved.
//

import UIKit

class JobSearchViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let resultsSegueIdentifier = "showResults"

    override func viewDidLoad() {
        super.viewDidLoad()

        formatTextField(keywordsTextField, text: "Job title or keywords")
        formatButton(searchButton, text: "Search")
        formatLogoImageView()

        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        logoImageView.transform = CGAffineTransformConcat(scale, translate)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: {
            self.logoImageView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        textField.backgroundColor = .whiteColor()

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
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        print("keywords \(keywordsTextField.text)")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == resultsSegueIdentifier {
            let searchResults = segue.destinationViewController as? SearchResultsViewController
            searchResults?.keywords = keywordsTextField.text
        }
    }

}
