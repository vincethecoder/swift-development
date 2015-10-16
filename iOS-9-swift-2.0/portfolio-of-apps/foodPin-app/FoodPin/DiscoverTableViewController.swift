//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 10/15/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants:[CKRecord] = []
    
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    
    var imageCache:NSCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Busy spinner
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
       
        // iCloudKit
        getRecordsFromCloud()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .whiteColor()
        refreshControl?.tintColor = .grayColor()
        refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecordsFromCloud() {
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]

        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "location"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
        }
        
        // Operational API Example ...
        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
 
            self.spinner.startAnimating()
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                print("Failed to get data from iCloud - \(error!.localizedDescription)")
                return
            }
            
            print("Successfully retrieve the data from iCloud")
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.tableView.reloadData()
            }
        
        }
        
        // Execute the query
        publicDatabase.addOperation(queryOperation)
        
    /*
        // Convenience API Example ...
        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
            (results, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            if let results = results {
                print("Completed the download of Restaurant data")
                self.restaurants = results
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    self.tableView.reloadData()
                }
            }
        })
    */

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverCell", forIndexPath: indexPath) as! DiscoverTableViewCell

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.objectForKey("name") as? String
        cell.typeLabel.text = restaurant.objectForKey("type") as? String
        cell.locationLabel.text = restaurant.objectForKey("location") as? String
        
        // Set default image
        cell.bgImageView.image = nil
        
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
            
            // Fetch image from cache
            print("Get image from cache")
            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
        } else {
            // Fetch Image from Cloud in background - "Lazy Loading"
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .VeryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void  in
                if error != nil {
                    print("Failed to get restaurant immage \(error?.localizedDescription)")
                    return
                }
                
                if let restaurantRecord = record {
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
                            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                            
                            // Add the image URL to cache
                            self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
            
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }

        return cell
    }

}
