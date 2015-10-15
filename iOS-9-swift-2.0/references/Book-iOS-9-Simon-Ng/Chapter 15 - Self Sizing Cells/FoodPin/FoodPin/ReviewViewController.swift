//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/29/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var ratingStackView:UIStackView!
    
    enum RatingCode: Int {
        case CodeDislike = 100
        case CodeGood = 200
        case CodeGreat = 300
    }
    
    var rating:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)

        // ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        // ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
    }
    
    override func viewDidAppear(animated: Bool) {

        // Regular animation
//        UIView.animateWithDuration(1.0, delay: 0.0, options: [], animations: {
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
        
        // Spring animation
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            self.ratingStackView.transform = CGAffineTransformIdentity
            }, completion: nil)

    }
    
    @IBAction func ratingSelected(sender: UIButton) {
        
        if let buttonTag = RatingCode(rawValue: sender.tag) {
            switch (buttonTag) {
            case .CodeDislike:
                rating = "dislike"
            case .CodeGood:
                rating = "good"
            case .CodeGreat:
                rating = "great"
            }
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
