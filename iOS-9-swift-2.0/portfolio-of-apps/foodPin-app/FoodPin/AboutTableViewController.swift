//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 10/13/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Leave Feedback", "Follow Us"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"], ["Github", "Twitter", "Instagram"]]
    var links = ["https://github.com/vincethecoder", "https://twitter.com/vincethecoder", "https://instagram.com/vincethecoder"]

    enum AboutTableSection : Int {
        case ImageSection = 0
        case OtherSection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove the separators of the empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AboutTableSection(rawValue: section) == .ImageSection {
            return 2
        } else {
            return 3
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        // Leave me a feedback
        case 0:
            if indexPath.row == 0 {
                if let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegueWithIdentifier("showWebView", sender: self)
            }
        // Follow me Section
        case 1:
            if let url = NSURL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                presentViewController(safariController, animated: true, completion: nil)
            }
        default:
            break
            
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }


}
