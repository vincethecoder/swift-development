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
    
    var build: [NSObject: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Search Bar
        addSearchBar()
        
        // Set Search Results Page Title
        title = "H1B Jobs Results"
        
        // Start Activity Indicator Animation
        GMDCircleLoader.setOn(self.view, withTitle: "Searching...", animated: true)
        
        self.tableView.separatorStyle = .none
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Initiate Job Search Request
        let job: Job = Job()
        job.keywords = keywords
        job.getJobs { (success, result, listings, error) -> () in
            
            // Stop Activity Indicator Animation
            DispatchQueue.main.async { [weak self] in
                GMDCircleLoader.hide(from: self?.tableView, animated: true)
                self?.tableView.separatorStyle = .singleLine
                self?.tableView.layer.shadowRadius = 10
            }
            

            if success {
                self.jobListings = listings ?? []
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    let jobcount = strongSelf.jobListings.count > 0 ? "\(strongSelf.jobListings.count)" : "No"
                    strongSelf.title = "\(jobcount) Jobs Found"
                    
                    if strongSelf.jobListings.count > 0 {
                        strongSelf.addDefaultView(viewTitle: String(), viewText: String(), viewImage: UIImage())
                        strongSelf.tableView.reloadData()
                    } else {
                        strongSelf.searchDefaultViewTitle = "No Job Match"
                        strongSelf.searchDefaultViewText = "Sorry! There are no H1B Jobs that \nmatch those search keywords."
                        strongSelf.searchDefaultViewImage = UIImage(named: "search_filled_gray")
                        strongSelf.addDefaultView(viewTitle: strongSelf.searchDefaultViewTitle, viewText: strongSelf.searchDefaultViewText, viewImage: strongSelf.searchDefaultViewImage)
                        strongSelf.searchDefaultView.isHidden = false
                    }
                }
                
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.title = "H1B Jobs"
                    
                    if error?.code == 3840 {
                        strongSelf.searchDefaultViewText = "Ooops. Looks like you're on a restricted \nnetwork. Switch your wi-fi connection."
                    } else {
                        strongSelf.searchDefaultViewText = "\(error?.localizedDescription)"
                    }
                    
                    strongSelf.searchDefaultViewTitle = "Wi-Fi Connection Error"
                    strongSelf.searchDefaultViewImage = UIImage(named: "offline_filled_gray")
                    
                    strongSelf.addDefaultView(viewTitle: strongSelf.searchDefaultViewTitle, viewText: strongSelf.searchDefaultViewText, viewImage: strongSelf.searchDefaultViewImage)
                    strongSelf.searchDefaultView.isHidden = false
                }
            }
        }
    }
    
    func addDefaultView(viewTitle: String, viewText: String, viewImage: UIImage) {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
        searchDefaultView = ErrorView(frame: frame, title: viewTitle,text: viewText, image: viewImage)
        searchDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(searchDefaultView)
        tableView.bringSubview(toFront: searchDefaultView)
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.jobListings.count > 0 {
                strongSelf.tableView.reloadData()
            }
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
        searchController.searchBar.barTintColor = UIColor.H1BBorderColor()
        
        // Prevents undefined behavior in app lifecyle
        searchController.loadViewIfNeeded()

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
        cell.jobPostDate.text = "Posted: \(h1bjob.postdate.wordMonthDayString())"
        cell.imageView?.image = h1bjob.companyLogo
        
        cell.jobWebUrl = h1bjob.jobUrl
        cell.delegate = self
        
        let record = favoriteJobs.filter { $0.jobTitle.lowercased() == h1bjob.title.lowercased() && $0.company.lowercased() == h1bjob.company.lowercased() }
        cell.saveButton.tintColor = record.isEmpty == false ? UIColor.red : UIColor.lightGray
        
        return cell
    }
    
    func saveButtonTapped(cell: ResultsTableViewCell) {
        
        let companyLogo = UIImagePNGRepresentation((cell.imageView?.image)!)
        let jobRecord = Favorite(favoriteId: 0, jobTitle: cell.jobTitle.text!, company: cell.jobCompany.text!, jobUrl: cell.jobWebUrl, savedTimestamp: Date.init().wordMonthDayYearString(), image: companyLogo!)

        
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
            let favoriteId = FavoriteHelper.insert(item: jobRecord)
            print("favorite id \(favoriteId)")
        }
        
        updateFavoriteTabBadge()
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray?.object(at: 1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        // Orientation Change - Google Analytics
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        let senderView = (sender as! UIView)
        let center = senderView.center
        let rootViewPoint = senderView.superview?.convert(center, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: rootViewPoint!) {
            let webView = segue.destination as? JobWebViewController
            let row = indexPath.row
            let h1bjob = (searchController.isActive) ? searchResults[row] : jobListings[row]
            webView?.jobUrl = h1bjob.jobUrl
            webView?.job = Favorite(favoriteId: 0, jobTitle: h1bjob.title, company: h1bjob.company, jobUrl: h1bjob.jobUrl, savedTimestamp: h1bjob.postdate.wordMonthDayString(), image: UIImagePNGRepresentation(h1bjob.companyLogo)!)
        }
       
    }

    // MARK: - Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchResults = jobListings.filter({ (job:H1BJob) -> Bool in
            let titleMatch = job.title.lowercased().range(of: searchText)
            let locationMatch = job.location.lowercased().range(of: searchText)
            return titleMatch != nil || locationMatch != nil
        })
    }

    func updateSearchResults(for searchController: UISearchController) {
        // Protocol method
    }
}
