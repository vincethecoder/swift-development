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

        if let _ = inlineMessage where inlineMessage?.characters.count > 0 {
            return cell.noListingsCell(inlineMessage!)
        } else {
            let row = indexPath.row
            let historyData = historyList[row]
            let keyword = historyData.keyword?.characters.count > 0 ? historyData.keyword?.capitalizedString : "Any H1B Job"
            cell.jobKeyword.text = "\(keyword!)"
            cell.jobSearchDate.text = "Searched: \(historyData.timestamp!)"
            cell.textLabel?.text = ""
            return cell
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row = indexPath.row
            HistoryHelper.delete(historyList[row])
            guard historyList.count != row else { return }
            historyList.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
