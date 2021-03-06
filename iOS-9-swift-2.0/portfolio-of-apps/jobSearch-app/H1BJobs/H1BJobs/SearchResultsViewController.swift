//
//  SearchResultsTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/28/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SearchResultsViewController: UITableViewController, UISearchResultsUpdating, ResultsTableViewCellDelegate {
    
    var keywords: String?
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
        let jobs = FavoriteHelper.findAll()!
        return jobs
    }
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = AppSecrets.admobAdUnitID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        let adRequest = GADRequest()
        adRequest.testDevices = [ kGADSimulatorID, AppSecrets.testDeviceID ]
        adBannerView.load(GADRequest())

        // Add Search Bar
        addSearchBar()
        
        // Set Search Results Page Title
        title = "H1B Jobs Results"
        
        // Start Activity Indicator Animation
        _ = GMDCircleLoader.setOn(self.view, withTitle: "Searching...", animated: true)
        
        self.tableView.separatorStyle = .none
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        // Initiate Job Search Request
        let job: Job = Job()
        job.keywords = keywords
        job.getJobs { (success, result, joblistings, error) in
            
            // Stop Activity Indicator Animation
            DispatchQueue.main.async {
                GMDCircleLoader.hide(from: self.tableView, animated: true)
                self.tableView.separatorStyle = .singleLine
                self.tableView.layer.shadowRadius = 10
            }

            if success, let joblistings = joblistings {
                self.jobListings = joblistings
                DispatchQueue.main.async {
                    let jobcount = self.jobListings.count > 0 ? "\(self.jobListings.count)" : "No"
                    self.title = "\(jobcount) Jobs Found"
                    
                    if self.jobListings.count > 0 {
                        self.searchDefaultViewTitle = nil
                        self.searchDefaultViewText = nil
                        self.searchDefaultViewImage = nil
                        self.searchDefaultView.isHidden = true
                        self.addDefaultView(String(), viewText: String(), viewImage: UIImage())
                        self.tableView.reloadData()
                    } else {
                        self.searchDefaultViewTitle = "No Job Match"
                        self.searchDefaultViewText = "Sorry! There are no H1B Jobs that \nmatch those search keywords."
                        self.searchDefaultViewImage = UIImage(named: "search_filled_gray")
                        self.addDefaultView(self.searchDefaultViewTitle, viewText: self.searchDefaultViewText, viewImage: self.searchDefaultViewImage)
                        self.searchDefaultView.isHidden = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.title = "H1B Jobs"
                    
                    self.searchDefaultViewText = "\(error!.localizedDescription)"
                    
                    self.searchDefaultViewTitle = "Wi-Fi Connection Error"
                    self.searchDefaultViewImage = UIImage(named: "offline_filled_gray")

                    self.addDefaultView(self.searchDefaultViewTitle, viewText: self.searchDefaultViewText, viewImage: self.searchDefaultViewImage)
                    self.searchDefaultView.isHidden = false
                }
            }
        }
    }
    
    deinit {
        keywords = nil
        tableView = nil
        searchController = nil
        searchDefaultView = nil
        searchDefaultViewText = nil
        searchDefaultViewTitle = nil
        searchDefaultViewImage = nil

        Job.queue.cancelAllOperations()
        jobListings.removeAll()
        searchResults.removeAll()
    }
    
    func addDefaultView(_ viewTitle: String, viewText: String, viewImage: UIImage) {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
        searchDefaultView = ErrorView(frame: frame, title: viewTitle,text: viewText, image: viewImage)
        searchDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(searchDefaultView)
        tableView.bringSubviewToFront(searchDefaultView)
        let widthConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewWidth)
        searchDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewHeight)
        searchDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: 0)
        tableView.addConstraint(yCenterConstraint)
        
        searchDefaultView.isHidden = true
        
        // Apply a blurring effect to the background image view
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if jobListings.count > 0 {
            tableView.reloadData()
        }
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "/searchresutlsview")
        let builder = GAIDictionaryBuilder.createScreenView()
        if let trackedData = builder?.build() {
            tracker?.send(trackedData as [NSObject : AnyObject])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = UIColor.H1BBorderColor
        
        // Prevents undefined behavior in app lifecyle
        searchController.loadViewIfNeeded()

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adBannerView.frame.height
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.isActive) ? searchResults.count : jobListings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultsTableViewCell
        
        let row = indexPath.row
        let h1bjob = (searchController.isActive) ? searchResults[row] : jobListings[row]

        cell.backgroundColor = .clear

        cell.jobTitle.text = h1bjob.title.capitalized
        cell.jobCompany.text = h1bjob.company
        cell.jobLocation.text = h1bjob.location
        cell.jobPostDate.text = "Posted: \(h1bjob.postdate.wordMonthDayString)"
        cell.imageView?.image = h1bjob.companyLogo
        
        cell.jobWebUrl = h1bjob.jobUrl
        cell.delegate = self
        
        let record = favoriteJobs.filter { $0.jobTitle.lowercased() == h1bjob.title.lowercased() && $0.company.lowercased() == h1bjob.company.lowercased() }
        cell.saveButton.tintColor = record.isEmpty == false ? UIColor.red : UIColor.lightGray
        
        return cell
    }
    
    func saveButtonTapped(_ cell: ResultsTableViewCell) {
        
        let center = cell.center
        guard let rootViewPoint = cell.superview?.convert(center, to: tableView),
              let indexPath = tableView.indexPathForRow(at: rootViewPoint) else {
            return
        }
        
        let job = jobListings[indexPath.row]
        
        let jobRecord = Favorite(favoriteId: 0, jobTitle: cell.jobTitle.text!, company: cell.jobCompany.text!, jobUrl: cell.jobWebUrl, savedTimestamp: Date().wordMonthDayYearString, image: job.companyLogoName)

        
        if let record = FavoriteHelper.find(item: jobRecord) {
            let success: Bool = FavoriteHelper.delete(item: record)
            
            if success == true {
                cell.saveButton.tintColor = UIColor.lightGray
            }
        } else {
            let tintColor = cell.saveButton.tintColor == UIColor.red ? UIColor.lightGray : UIColor.red
            cell.saveButton.tintColor = tintColor
        }

        if cell.saveButton.tintColor == UIColor.red {
            _ = FavoriteHelper.insert(item: jobRecord)
        }
        
        updateFavoriteTabBadge()
    }
    
    func tableRowButtonTapped(_ sender: Any) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateFavoriteTabBadge() {
        if let tabArray = self.tabBarController?.tabBar.items {
            let favoriteTab = tabArray[1]
            let favoriteCount = FavoriteHelper.count()
            favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
        }
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        // Orientation Change - Google Analytics
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "Orientation Change", action: "Device in Landscape", label: "Landscape Orientation", value: nil).build() as [NSObject : AnyObject])
        }
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let senderObject = (sender as AnyObject)
        if let center = senderObject.center,
           let rootViewPoint = senderObject.superview?.convert(center, to: tableView),
           let indexPath = tableView.indexPathForRow(at: rootViewPoint),
           let webView = segue.destination as? JobWebViewControler {
           let row = indexPath.row
            let job = searchController.isActive ? searchResults[row] : jobListings[row]
            webView.jobUrl = job.jobUrl
            webView.job = Favorite(favoriteId: 0, jobTitle: job.title, company: job.company, jobUrl: job.jobUrl, savedTimestamp: job.postdate.wordMonthDayString, image: job.companyLogoName)   
        }
    }

    // MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchResults = jobListings.filter({ (job:H1BJob) -> Bool in
            let titleMatch = job.title.range(of: searchText, options: .caseInsensitive)
            let locationMatch = job.location.range(of: searchText, options: .caseInsensitive)
            return titleMatch != nil || locationMatch != nil
        })
    }

}

extension SearchResultsViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
