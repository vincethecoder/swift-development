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
    var inlineMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search Results Page Title
        title = "Search History"

        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        inlineMessage = "No Search History... Let's Being Search!"
        
        let inset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.contentInset = inset
        
        // Apply a blurring effect to the background image view
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width * 2, view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
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
            inlineMessage = ""
        } else {
            self.historyList = [History()]
        }

        tableView.reloadData()
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
        
        if let _ = inlineMessage where inlineMessage?.characters.count > 0 {
            cell.historyLocation.hidden = true
            cell.historyLocationIcon.hidden = true
            cell.historySearchIcon.hidden = true
            cell.imageView?.hidden = true
            cell.jobKeyword.text = ""
            return cell.noListingsCell(inlineMessage!)
        } else {
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
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row = indexPath.row
            HistoryHelper.delete(historyList[row])
            guard historyList.count > row else { return }
            historyList.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if historyList.count == 0 {
                inlineMessage = "No Search History... Let's Being Search!"
                historyList = [History()]
                tableView.reloadData()
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
