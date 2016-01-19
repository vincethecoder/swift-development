//
//  SearchResultsTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController, UISearchResultsUpdating, ResultsTableViewCellDelegate {
    
    var keywords: String?
    var jobListings: [H1BJob] = []
    var searchResults: [H1BJob] = []
    var searchController: UISearchController!
    let cellIdentifier = "jobCell"
    let webViewSegueIdentifier = "jobHyperLink"
    var errorMessage: String!
    var dbFavJobs: [Favorite]!
    var favoriteJobs: [Favorite] {
        get {
            if let favoriteJobs = FavoriteHelper.findAll() {
                if dbFavJobs != nil && dbFavJobs.count > 0 {
                    dbFavJobs.removeAll()
                } else {
                    dbFavJobs = []
                }
                for job in favoriteJobs {
                    dbFavJobs.append(job)
                }
            }
            return dbFavJobs
        }
    }

    let tableHeightSingleLine: CGFloat = 90
    let tableHeightErrorCell: CGFloat = 45

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var searchSource: UILabel!
    
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    
    var build: [NSObject: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Search Bar
        addSearchBar()
        
        // Set Search Results Page Title
        title = "H1B Jobs Results"
        
        // Start Activity Indicator Animation
        GMDCircleLoader.setOnView(self.view, withTitle: "Searching...", animated: true)
        
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
                
                GMDCircleLoader.hideFromView(self.view, animated: true)
                self.tableView.separatorStyle = .SingleLine
                self.tableView.layer.shadowRadius = 10
            })

            self.jobListings = [H1BJob()]
            if success, let _ = joblistings {
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
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "/searchresutlsview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            var imageUrl = ""

            if h1bjob.jobdetail.isKindOfClass(DiceJobDetail) {
                imageUrl = "http://seeker.dice.com/assets/images/DiceLogo_V.gif"
            } else if h1bjob.jobdetail.isKindOfClass(CBJobDetail) {
                if let cbJobDetail = h1bjob.jobdetail as? CBJobDetail {
                    if let _ = cbJobDetail.companyImageURL {
                        imageUrl = cbJobDetail.companyImageURL!
                    }
                }
            } else if h1bjob.jobdetail.isKindOfClass(LinkupJobDetail) {
                imageUrl = "http://www.linkup.com/images/opengraph/LinkUpLogo180x110.png"
            } else if h1bjob.jobdetail.isKindOfClass(IndeedJobDetail) {
                imageUrl = "http://p2.zdassets.com/hc/settings_assets/499832/200031240/Cw6ZzmMTxxN4ArRyhXrdqQ-indeed.png"
            }

            cell.jobTitle.text = h1bjob.title.capitalizedString
            cell.jobCompany.text = h1bjob.company
            cell.jobLocation.text = h1bjob.location
            cell.jobPostDate.text = "Posted: \(h1bjob.postdate.wordFullMonthDayYearString())"
            
            if imageUrl.characters.count > 0 {
                ImageLoader.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
                    if image != nil {
                        cell.jobCompanyLogo.image = image
                    }
                })
            } else {
                cell.jobCompanyLogo.image = UIImage(named: "cbLogo")
            }
            
            cell.jobWebUrl = h1bjob.jobUrl
            cell.delegate = self

            let record = favoriteJobs.filter { $0.jobTitle == h1bjob.title && $0.company == h1bjob.company }
            cell.saveButton.tintColor = record.isEmpty == false ? UIColor.redColor() : UIColor.lightGrayColor()
            
            return cell
        }
    }
    
    func saveButtonTapped(cell: ResultsTableViewCell) {
        
        let companyLogo = UIImagePNGRepresentation((cell.jobCompanyLogo?.image)!)
        let jobRecord = Favorite(favoriteId: 0, jobTitle: cell.jobTitle.text!, company: cell.jobCompany.text!, jobUrl: cell.jobWebUrl, savedTimestamp: NSDate.init().wordMonthDayYearString(), image: companyLogo!)

        
        if let record = FavoriteHelper.find(jobRecord) {
            let success: Bool = FavoriteHelper.delete(record)
            
            if success == true {
                cell.saveButton.tintColor = UIColor.lightGrayColor()
            }
        } else {
            let tintColor = cell.saveButton.tintColor == UIColor.redColor() ? UIColor.lightGrayColor() : UIColor.redColor()
            cell.saveButton.tintColor = tintColor
        }

        if cell.saveButton.tintColor == UIColor.redColor() {
            let favoriteId = FavoriteHelper.insert(jobRecord)
            print("favorite id \(favoriteId)")
        }

    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // @TODO: Orientation Change - Google Analytics
        if toInterfaceOrientation == .LandscapeLeft || toInterfaceOrientation == .LandscapeRight {
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Orientation Change", action: "Device in Landscape", label: "Landscape Orientation", value: nil).build() as [NSObject : AnyObject])
        }
        
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let _ = errorMessage where errorMessage?.characters.count > 0 {
            return tableHeightErrorCell
        } else {
            let row = indexPath.row
            let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                let unknownCompanyHeightOffset: CGFloat = h1bjob.company.characters.count == 0  ? 11 : 0
                let tableHeight: CGFloat = tableHeightSingleLine - unknownCompanyHeightOffset
                return tableHeight
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

        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: tableView)

        if let indexPath = tableView.indexPathForRowAtPoint(rootViewPoint!) {
            let webView = segue.destinationViewController as? JobWebViewControler
            let row = indexPath.row
            let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]
            webView?.jobUrl = h1bjob.jobUrl
        }
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
