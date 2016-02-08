//
//  SearchResultsCollectionViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 2/7/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class SearchResultsCollectionViewController: UICollectionViewController, ResultsCollectionViewCellDelegate {

    var keywords: String!
    var jobListings: [H1BJob] = []
    var searchResults: [H1BJob] = []
    var searchController: UISearchController!
    
    let reuseIdentifier = "jobCell"
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
    
    var tracker: GAITracker {
        return GAI.sharedInstance().defaultTracker
    }
    
    var build: [NSObject: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Search Results Page Title
        title = "H1B Jobs Results"
        
        // Start Activity Indicator Animation
        GMDCircleLoader.setOnView(self.view, withTitle: "Searching...", animated: true)
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        // Initiate Job Search Request
        let job: Job = Job()
        job.keywords = keywords
        job.getJobs { (success, result, joblistings, error) -> () in
            
            // Stop Activity Indicator Animation
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                GMDCircleLoader.hideFromView(self.view!, animated: true)
            })
            
            if success, let _ = joblistings {
                self.jobListings = joblistings!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let jobcount = self.jobListings.count > 0 ? "\(self.jobListings.count)" : "No"
                    self.title = "\(jobcount) Jobs Found"
                    
                    if self.jobListings.count > 0 {
                        self.addDefaultView(String(), viewText: String(), viewImage: UIImage())
                        self.collectionView!.reloadData()
                    } else {
                        self.searchDefaultViewTitle = "Sorry we couldn't find any \(self.keywords.capitalizedString) jobs"
                        self.searchDefaultViewText = "Perhaps change your keyword(s) as we continue to work diligently on expanding our search database."
                        self.searchDefaultViewImage = UIImage(named: "search_filled_gray")
                        self.addDefaultView(self.searchDefaultViewTitle, viewText: self.searchDefaultViewText, viewImage: self.searchDefaultViewImage)
                        self.searchDefaultView.hidden = false
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.title = "H1B Jobs"
                    
                    if error?.code == 3840 {
                        self.searchDefaultViewText = "Ooops. Looks like you're on a restricted \nnetwork. Switch your wi-fi connection."
                    } else {
                        self.searchDefaultViewText = "\(error!.localizedDescription)"
                    }
                    
                    self.searchDefaultViewTitle = "Wi-Fi Connection Error"
                    self.searchDefaultViewImage = UIImage(named: "offline_filled_gray")
                    
                    self.addDefaultView(self.searchDefaultViewTitle, viewText: self.searchDefaultViewText, viewImage: self.searchDefaultViewImage)
                    self.searchDefaultView.hidden = false
                })
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if jobListings.count > 0 {
            collectionView!.reloadData()
        }
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "/searchresutlsview")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func addDefaultView(viewTitle: String, viewText: String, viewImage: UIImage) {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRectMake(0, 0, viewWidth, viewHeight)
        
        searchDefaultView = ErrorView(frame: frame, title: viewTitle,text: viewText, image: viewImage)
        searchDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView!.addSubview(searchDefaultView)
        collectionView!.bringSubviewToFront(searchDefaultView)
        let widthConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewWidth)
        searchDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        searchDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .CenterX, relatedBy: .Equal, toItem: collectionView!, attribute: .CenterX, multiplier: 1, constant: 0)
        collectionView!.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: searchDefaultView, attribute: .CenterY, relatedBy: .Equal, toItem: collectionView!, attribute: .CenterY, multiplier: 1, constant: 0)
        collectionView!.addConstraint(yCenterConstraint)
        
        searchDefaultView.hidden = true
        
        // Apply a blurring effect to the background image view
        collectionView!.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width * 2, view.bounds.height * 2)
        collectionView!.backgroundView!.addSubview(blurEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobListings.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ResultsCollectionViewCell
    
        let row = indexPath.row
        let h1bjob = jobListings[row]
        
        cell.backgroundColor = .clearColor()
        
        cell.jobTitle.text = h1bjob.title.capitalizedString
        cell.jobCompany.text = h1bjob.company
        cell.jobLocation.text = h1bjob.location
        cell.jobPostDate.text = "Posted: \(h1bjob.postdate.wordMonthDayString())"
        cell.imageView?.image = h1bjob.companyLogo
        
        cell.jobWebUrl = h1bjob.jobUrl
        cell.delegate = self
        
        let record = favoriteJobs.filter { $0.jobTitle.lowercaseString == h1bjob.title.lowercaseString && $0.company.lowercaseString == h1bjob.company.lowercaseString }
        cell.saveButton.tintColor = record.isEmpty == false ? UIColor.redColor() : UIColor.lightGrayColor()
        return cell
    }
    
    func saveButtonTapped(cell: ResultsCollectionViewCell) {
        
        let companyLogo = UIImagePNGRepresentation((cell.imageView?.image)!)
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
        
        updateFavoriteTabBadge()
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray.objectAtIndex(1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let center = (sender?.center)!
        let rootViewPoint = sender?.superview!!.convertPoint(center, toView: collectionView)
        
        if let indexPath = collectionView?.indexPathForItemAtPoint(rootViewPoint!) {
            let webView = segue.destinationViewController as? JobWebViewControler
            let row = indexPath.row
            let h1bjob = jobListings[row]
            webView?.jobUrl = h1bjob.jobUrl
            webView?.job = Favorite(favoriteId: 0, jobTitle: h1bjob.title, company: h1bjob.company, jobUrl: h1bjob.jobUrl, savedTimestamp: h1bjob.postdate.wordMonthDayString(), image: UIImagePNGRepresentation(h1bjob.companyLogo)!)
        }
    }

}

extension SearchResultsCollectionViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}