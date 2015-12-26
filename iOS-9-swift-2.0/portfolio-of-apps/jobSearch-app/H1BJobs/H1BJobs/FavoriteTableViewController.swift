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
    var inlineMessage: String?
    
    let tableHeightSingleLine: CGFloat = 81
    let tableHeightMultiLine: CGFloat = 97
    let tableHeightErrorCell: CGFloat = 45

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Search Results Page Title
        title = "Saved Jobs"
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        inlineMessage = "No Saved Jobs... Let's Begin Search!"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favoriteList = FavoriteHelper.findAll() {
            self.favoriteList.removeAll()
            for favorite in favoriteList {
                self.favoriteList.append(favorite)
            }
        }
        
        if self.favoriteList.count > 0 {
            inlineMessage = ""
        } else {
            self.favoriteList = [Favorite()]
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
        return favoriteList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let _ = inlineMessage where inlineMessage?.characters.count > 0 {
            let cell = noListingsCell(tableView)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultsTableViewCell
            
            let row = indexPath.row
            let favoriteData = favoriteList[row]
            cell.jobTitle.text = favoriteData.jobTitle
            cell.jobCompany.text = favoriteData.company
            cell.jobPostDate.text = "Saved: \(favoriteData.savedTimestamp!)"
            cell.jobSource.text = favoriteData.source
            
            return cell
        }
    }
    
    func noListingsCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        cell?.textLabel?.attributedText = NSMutableAttributedString(
            string: NSLocalizedString(inlineMessage!, comment: ""),
            attributes:[NSFontAttributeName: UIFont.systemFontOfSize(12),
                NSForegroundColorAttributeName: UIColor.H1BTextColor()])
        cell?.textLabel?.numberOfLines = 0
        cell?.selectionStyle = .None
        cell?.accessoryType = .None
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let _ = inlineMessage where inlineMessage?.characters.count > 0 {
            return tableHeightErrorCell
        } else {
            let row = indexPath.row
            let h1bjob = favoriteList[row]
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                return h1bjob.jobTitle?.characters.count < 60 ? tableHeightSingleLine : tableHeightMultiLine
            } else {
                return tableHeightSingleLine
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row = indexPath.row
            FavoriteHelper.delete(favoriteList[row])
            guard favoriteList.count != row else { return }
            favoriteList.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
