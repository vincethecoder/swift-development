//
//  SearchResultsTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController, UISearchResultsUpdating, ResultsTableViewCellDelegate {
    
    var keywords: String! {
        didSet {
            keywords = keywords.removeBadChars
        }
    }
    var jobListings: [H1BJob] = []
    var searchResults: [H1BJob] = []
    var searchController: UISearchController!
    let cellIdentifier = "jobCell"
    let webViewSegueIdentifier = "jobHyperLink"
    var searchDefaultView: ErrorView!
    var searchDefaultViewTitle: String!
    var searchDefaultViewText: String!
    var searchDefaultViewImage: UIImage!
    var favoriteJobs: [Favorite] {
        get {
            let jobs = FavoriteHelper.findAll()!
            return jobs
        }
    }

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
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                guard let strongSelf = self else { return }
                GMDCircleLoader.hideFromView(strongSelf.view, animated: true)
                strongSelf.tableView.separatorStyle = .SingleLine
                strongSelf.tableView.layer.shadowRadius = 10
            })

            if success, let joblistings = joblistings {
                self.jobListings = joblistings
                dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                    guard let strongSelf = self else { return }
                    let jobcount = strongSelf.jobListings.count > 0 ? "\(strongSelf.jobListings.count)" : "No"
                    strongSelf.title = "\(jobcount) Jobs Found"
                    
                    if strongSelf.jobListings.count > 0 {
                        strongSelf.addDefaultView(String(), viewText: String(), viewImage: UIImage())
                        strongSelf.tableView.reloadData()
                    } else {
                        strongSelf.searchDefaultViewTitle = "Sorry we couldn't find any \(strongSelf.keywords.capitalizedString) jobs"
                        strongSelf.searchDefaultViewText = "Perhaps change your keyword(s) as we continue to work diligently on expanding our search database."
                        strongSelf.searchDefaultViewImage = UIImage(named: "search_filled_gray")
                        if let searchTitle = strongSelf.searchDefaultViewTitle, searchViewText = strongSelf.searchDefaultViewText, searchImage = strongSelf.searchDefaultViewImage {
                            strongSelf.addDefaultView(searchTitle, viewText: searchViewText, viewImage: searchImage)
                            strongSelf.searchDefaultView.hidden = false
                        }
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                    guard let strongSelf = self else { return }
                    strongSelf.title = "H1B Jobs"
                    
                    if error?.code == 3840 {
                        strongSelf.searchDefaultViewText = "Ooops. Looks like you're on a restricted \nnetwork. Switch your wi-fi connection."
                    } else {
                        strongSelf.searchDefaultViewText = "\(error!.localizedDescription)"
                    }
                    
                    strongSelf.searchDefaultViewTitle = "Wi-Fi Connection Error"
                    strongSelf.searchDefaultViewImage = UIImage(named: "offline_filled_gray")
                    
                    if let searchTitle = strongSelf.searchDefaultViewTitle, searchViewText = strongSelf.searchDefaultViewText, searchImage = strongSelf.searchDefaultViewImage {
                        strongSelf.addDefaultView(searchTitle, viewText: searchViewText, viewImage: searchImage)
                        strongSelf.searchDefaultView.hidden = false
                    }
                })
            }
        }
    }
    
    func addDefaultView(viewTitle: String, viewText: String, viewImage: UIImage) {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRectMake(0, 0, viewWidth, viewHeight)
        
        searchDefaultView = ErrorView(frame: frame, title: viewTitle,text: viewText, image: viewImage)
        searchDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(searchDefaultView)
        tableView.bringSubviewToFront(searchDefaultView)
        let widthConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewWidth)
        searchDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        searchDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        tableView.addConstraint(yCenterConstraint)
        
        searchDefaultView.hidden = true
        
        // Apply a blurring effect to the background image view
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width * 2, view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if jobListings.count > 0 {
            tableView.reloadData()
        }
        
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
        
        let row = indexPath.row
        let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]

        cell.backgroundColor = .clearColor()

        if let jobTitle = h1bjob.title {
            cell.jobTitle.text = jobTitle.capitalizedString
        } else  {
            cell.jobTitle.text = nil
        }
        cell.jobCompany.text = h1bjob.company
        cell.jobLocation.text = h1bjob.location
        if let jobPostDate = h1bjob.postdate {
            cell.jobPostDate.text = "Posted: \(jobPostDate.wordMonthDayString())"
        } else {
            cell.jobPostDate.text = nil
        }
        cell.imageView?.image = h1bjob.companyLogo
        
        cell.jobWebUrl = h1bjob.jobUrl
        cell.delegate = self
        
        let record = favoriteJobs.filter {
            $0.jobTitle!.lowercaseString == h1bjob.title!.lowercaseString && $0.company!.lowercaseString == h1bjob.company!.lowercaseString }
        cell.saveButton.tintColor = record.isEmpty == false ? UIColor.redColor() : UIColor.lightGrayColor()
        
        return cell
    }
    
    func saveButtonTapped(cell: ResultsTableViewCell) {
        
        let companyLogo = UIImagePNGRepresentation((cell.imageView?.image)!)
        let jobRecord = Favorite(favoriteId: 0, jobTitle: cell.jobTitle.text, company: cell.jobCompany.text, jobUrl: cell.jobWebUrl, savedTimestamp: NSDate().wordMonthDayYearString(), image: companyLogo)

        
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
        
        updateFavoriteTabBadge()
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray.objectAtIndex(1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // Orientation Change - Google Analytics
        if toInterfaceOrientation == .LandscapeLeft || toInterfaceOrientation == .LandscapeRight {
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Orientation Change", action: "Device in Landscape", label: "Landscape Orientation", value: nil).build() as [NSObject : AnyObject])
        }
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: tableView)

        if let rootViewPoint = rootViewPoint, indexPath = tableView.indexPathForRowAtPoint(rootViewPoint) {
            let webView = segue.destinationViewController as? JobWebViewControler
            let row = indexPath.row
            let h1bjob = (searchController.active) ? searchResults[row] : jobListings[row]
            webView?.jobUrl = h1bjob.jobUrl
            
            if let jobPostDate = h1bjob.postdate, companyLogo = h1bjob.companyLogo {
                webView?.job = Favorite(favoriteId: 0, jobTitle: h1bjob.title, company: h1bjob.company, jobUrl: h1bjob.jobUrl, savedTimestamp: jobPostDate.wordMonthDayString(), image: UIImagePNGRepresentation(companyLogo))
            }
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
            let titleMatch = job.title!.rangeOfString(searchText, options:.CaseInsensitiveSearch)
            let locationMatch = job.location!.rangeOfString(searchText, options:.CaseInsensitiveSearch)
            return titleMatch != nil || locationMatch != nil
        })
    }

}
