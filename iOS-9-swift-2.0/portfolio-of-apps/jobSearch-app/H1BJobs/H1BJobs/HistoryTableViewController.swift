//
//  HistoryTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/14/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var historyList: [History] = []
    let cellIdentifier = "historyCell"
    let resultsSegueIdentifier = "historyResults"
    var historyDefaultView: ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search Results Page Title
        title = "Search History"

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
        
        // Add "No History Transcript Available" View
        addDefaultView()
        
    }
    
    func addDefaultView() {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRectMake(0, 0, viewWidth, viewHeight)

        historyDefaultView = ErrorView(frame: frame, title: "It's pretty quiet around here",
                                        text: "You'll begin to see a search history transcript \nwhen you search for jobs",
                                       image: UIImage(named: "clock_filled_gray")!)
        historyDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(historyDefaultView)
        tableView.bringSubviewToFront(historyDefaultView)
        let widthConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewWidth)
        historyDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        historyDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: -35)
        tableView.addConstraint(yCenterConstraint)
        
        historyDefaultView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let historyList = HistoryHelper.findAll() {
            self.historyList.removeAll()
            for history in historyList {
                self.historyList.append(history)
            }
        }
        
        if self.historyList.count > 0 {
            historyDefaultView.hidden = true
            tableView.reloadData()
        } else {
            historyDefaultView.hidden = false
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "/historyview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell

        cell.backgroundColor = .clearColor()
        
        let row = indexPath.row
        let historyData = historyList[row]
        let keyword = historyData.keyword?.characters.count > 0 ? historyData.keyword?.capitalizedString : "All H1B Jobs"
        
        cell.historyLocationIcon.hidden = false
        cell.historySearchIcon.hidden = false
        cell.historyLocation.hidden = false
        cell.imageView?.hidden = false
        cell.jobKeyword.text = "\(keyword!)"
        cell.textLabel?.text = ""
        cell.imageView?.image = UIImage(named: "calendar_full")
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row = indexPath.row
            HistoryHelper.delete(historyList[row])
            guard historyList.count > row else { return }
            historyList.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            if historyList.count == 0 {
                historyDefaultView.hidden = false
            } else {
                historyDefaultView.hidden = true
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == resultsSegueIdentifier,
        let indexPath = tableView.indexPathForSelectedRow {
            let searchResults = segue.destinationViewController as? SearchResultsViewController
            let row = indexPath.row
            let historyData = historyList[row]
            searchResults?.keywords = historyData.keyword
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }

}
