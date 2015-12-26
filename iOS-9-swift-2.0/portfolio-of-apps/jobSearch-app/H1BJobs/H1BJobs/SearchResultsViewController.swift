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

    let tableHeightSingleLine: CGFloat = 81
    let tableHeightMultiLine: CGFloat = 97
    let tableHeightErrorCell: CGFloat = 45
    
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
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultsTableViewCell
        
        if let _ = errorMessage where errorMessage?.characters.count > 0 {
            return cell.noListingsCell(errorMessage!)
        } else {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let _ = errorMessage where errorMessage?.characters.count > 0 {
            return tableHeightErrorCell
        } else {
            let row = indexPath.row
            let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                return h1bjob.title.characters.count < 60 ? tableHeightSingleLine : tableHeightMultiLine
            } else {
                return tableHeightSingleLine
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
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
