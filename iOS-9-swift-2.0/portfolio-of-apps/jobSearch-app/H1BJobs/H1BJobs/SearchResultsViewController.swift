//
//  SearchResultsTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController, UISearchResultsUpdating {
    
    var keywords: String?
    var jobListings: [H1BJob] = []
    var searchResults: [H1BJob] = []
    var searchController: UISearchController!
    let cellIdentifier = "jobCell"
    var errorMessage: String?
    
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var searchSource: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Search Bar
        addSearchBar()
        
        // Set Search Results Page Title
        title = "H1B Jobs Results"
        
        // Start Activity Indicator Animation
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        
        self.tableView.separatorStyle = .None
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Initiate Job Search Request
        let job: Job = Job()
        job.keywords = keywords
        job.getJobs { (success, result, joblistings, error) -> () in
            
            // Stop Activity Indicator Animation
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.spinner.stopAnimating()
                self.tableView.separatorStyle = .SingleLine
            })
            
            self.errorMessage = "Connection Failure. Switch your Wi-fi connection"
            self.jobListings = [H1BJob()]
            if success {
                self.jobListings = joblistings!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let jobcount = self.jobListings.count > 0 ? "\(self.jobListings.count)" : "No"
                    self.title = "\(jobcount) Jobs Found"
                    self.tableView.reloadData()
                })
            } else {
                if error!.code == 3840 {
                    self.errorMessage = "Connection Failure. Switch your Wi-fi connection"
                } else {
                    self.errorMessage = "No Job Match"
                }

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.title = "H1B Jobs"
                    self.tableView.reloadData()
                })
            }
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func addSearchBar() {
        // Add a Search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Customize the appearance of the search bar
        searchController.searchBar.placeholder = "Filter Listings..."
        searchController.searchBar.tintColor = .whiteColor()
        searchController.searchBar.barTintColor = UIColor.H1BBorderColor()
        
        // Prevents undefined behavior in app lifecyle
        searchController.loadViewIfNeeded()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.active) ? searchResults.count : jobListings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let _ = errorMessage where errorMessage?.characters.count > 0 {
            let cell = noListingsCellForTableView(tableView)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultsTableViewCell
            
            let row = indexPath.row
            let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]
            var source = ""
            
            if h1bjob.jobdetail.isKindOfClass(DiceJobDetail) {
                source = "Dice.com"
            } else if h1bjob.jobdetail.isKindOfClass(CBJobDetail) {
                source = "CareerBuilder.com"
            }
            cell.jobTitle.text = h1bjob.title.capitalizedString
            cell.jobCompany.text = h1bjob.company
            cell.jobLocation.text = h1bjob.location
            cell.jobPostDate.text = h1bjob.postdate.wordFullMonthDayYearString()
            cell.jobSource.text = "Source: \(source)"
            
            return cell
        }
    }
    
    func noListingsCellForTableView(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        cell?.textLabel?.attributedText = NSMutableAttributedString(
        string: NSLocalizedString(errorMessage!, comment: ""),
        attributes:[NSFontAttributeName: UIFont.systemFontOfSize(12),
        NSForegroundColorAttributeName: UIColor.H1BTextColor()])
        cell?.textLabel?.numberOfLines = 0
        cell?.selectionStyle = .None
        cell?.accessoryType = .None
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let _ = errorMessage where errorMessage?.characters.count > 0 {
            return 50
        } else {
            return 130
        }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = jobListings.filter({ (job:H1BJob) -> Bool in
            let titleMatch = job.title.rangeOfString(searchText, options:.CaseInsensitiveSearch)
            let locationMatch = job.location.rangeOfString(searchText, options:.CaseInsensitiveSearch)
            return titleMatch != nil || locationMatch != nil
        })
    }
}
