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
    
    var build: [NSObject: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let keywordPlaceholder = "Job title or keywords"
        formatTextField(textField: keywordsTextField, text: keywordPlaceholder)
        formatButton(button: searchButton, text: "Search")
        formatLogoImageView()

        let font = UIFont(name: "Avenir", size: 18)!
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: font]
        keywordsTextField.attributedPlaceholder = NSAttributedString(string: keywordPlaceholder, attributes:attributes)
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        logoImageView.transform = scale.concatenating(translate)
        
        //Looks for single or multiple taps.
        //let tap = UITapGestureRecognizer(target: self, action: #selector(self.saveButtonTapped(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        // UITapGestureRecognizer(target: self, action: #selecter(self.dismissKeyboard()))
        view.addGestureRecognizer(tap)
        
        keywordsTextField.delegate = self
        
        view.backgroundColor = UIColor.H1BHeaderColor()
        view.alpha = 0.98
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.logoImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        
        let defaults = UserDefaults.standard
        let hasViewedWalkthrough = defaults.bool(forKey: "hasViewedWalkthrough")
        guard hasViewedWalkthrough == false else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateFavoriteTabBadge()
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray?.object(at: 1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }
    
    func formatLogoImageView() {
        logoImageView.layer.borderWidth = 1.0
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.H1BBorderColor().cgColor
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
        logoImageView.clipsToBounds = true
    }

    func blurBackgroundEffect() {
        // Apply a blurring effect to the background image view
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func formatTextField(textField: UITextField, text: String) {
        textField.attributedPlaceholder = NSAttributedString(string:text,
                                                             attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray])
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white

        textField.leftViewMode = .always
        textField.leftView = UIImageView(image: UIImage(named: "action_search"))
        
        textField.autocorrectionType = .yes
    }
    
    func formatButton(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)

        button.layer.cornerRadius = 8.0
        button.layer.borderColor = UIColor.H1BBorderColor().cgColor
        button.layer.borderWidth = 1.0

        button.layer.backgroundColor = UIColor.H1BHeaderColor().cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissVisibleKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        let keywords = keywordsTextField.text!
        let historyRecord = History(searchId: 0, keyword: keywords, location: "", state: "", timestamp: Date())
        let historyId = HistoryHelper.insert(item: historyRecord)
        print("history id \(historyId)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == resultsSegueIdentifier {
            let searchResults = segue.destination as? SearchResultsViewController
            searchResults?.keywords = keywordsTextField.text
        }
    }

}
