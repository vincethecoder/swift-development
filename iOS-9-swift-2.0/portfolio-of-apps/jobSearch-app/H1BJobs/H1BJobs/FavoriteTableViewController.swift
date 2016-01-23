//
//  FavoriteTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var favoriteList: [Favorite] = []
    let cellIdentifier = "favoriteCell"
    let webViewSegueIdentifier = "favJobHyperLink"
    var favoriteDefaultView: ErrorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Search Results Page Title
        title = "Saved Jobs"
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let inset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.contentInset = inset
        
        // Apply a blurring effect to the background image view
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width * 2, view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
        
        // Add "No Favorite Transcript Available" View
        addDefaultView()
    }
    
    func addDefaultView() {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRectMake(0, 0, viewWidth, viewHeight)
        
        favoriteDefaultView = ErrorView(frame: frame, title: "It's pretty quiet around here",
            text: "You'll see a list of favorite jobs \nwhen you start a search and save the jobs",
            image: UIImage(named: "like_filled_gray")!)
        favoriteDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(favoriteDefaultView)
        tableView.bringSubviewToFront(favoriteDefaultView)
        let widthConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewWidth)
        favoriteDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        favoriteDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: -35)
        tableView.addConstraint(yCenterConstraint)
        
        favoriteDefaultView.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favoriteList = FavoriteHelper.findAll() {
            self.favoriteList.removeAll()
            for favorite in favoriteList {
                self.favoriteList.append(favorite)
            }
        }
        
        tableView.reloadData()

        if self.favoriteList.count > 0 {
            favoriteDefaultView.hidden = true
        } else {
            favoriteDefaultView.hidden = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "/savedview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultsTableViewCell

        cell.backgroundColor = .clearColor()
        
        let row = indexPath.row
        let favoriteData = favoriteList[row]
        
        cell.jobTitle.text = favoriteData.jobTitle?.capitalizedString
        cell.jobCompany.text = favoriteData.company
        cell.jobPostDate.text = "Saved: \(favoriteData.savedTimestamp!)"
        
        cell.imageView?.image = UIImage(data: favoriteData.image)!
        cell.imageView?.hidden = false
        cell.textLabel?.text = ""
        cell.saveButton.tintColor = .redColor()
        cell.jobWebUrl = favoriteData.jobUrl
        cell.saveButton.hidden = false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row = indexPath.row
            FavoriteHelper.delete(favoriteList[row])
            guard favoriteList.count > row else { return }
            favoriteList.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if favoriteList.count == 0 {
                favoriteDefaultView.hidden = false
            } else {
                favoriteDefaultView.hidden = true
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: tableView)
        
        if let indexPath = tableView.indexPathForRowAtPoint(rootViewPoint!){
            let webView = segue.destinationViewController as? JobWebViewControler
            let row = indexPath.row
            let h1bjob = favoriteList[row]
            webView?.jobUrl = h1bjob.jobUrl
            webView?.job = h1bjob
        }
        
    }

}
