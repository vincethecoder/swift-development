//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/28/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var restaurants:[Restaurant] = [ Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend.jpg", isVisited: false), Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei.jpg", isVisited: false), Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha.jpg", isVisited: false), Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl.jpg", isVisited: false), Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster.jpg", isVisited: false), Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkeerestaurant.jpg", isVisited: false), Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier.jpg", isVisited: false), Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery.jpg", isVisited: false), Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haighschocolate.jpg", isVisited: false), Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palominoespresso.jpg", isVisited: false), Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate.jpg", isVisited: false), Restaurant(name: "Traif", type: "American", location: "New York", image: "traif.jpg", isVisited: false), Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "grahamavenuemeats.jpg", isVisited: false), Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "wafflewolf.jpg", isVisited: false), Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves.jpg", isVisited: false), Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore.jpg", isVisited: false), Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional.jpg", isVisited: false), Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina.jpg", isVisited: false), Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia.jpg", isVisited: false), Restaurant(name: "Royal Oak", type: "British", location: "London", image:"royaloak.jpg", isVisited: false), Restaurant(name: "Thai Cafe", type: "Thai", location: "London", image: "thaicafe.jpg", isVisited: false) ]
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell

        // Configure the cell ...
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .Checkmark : .None
        
        // Corner cells
        // cell.thumbnailImageView.layer.cornerRadius = 30.0
        // cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            restaurants.removeAtIndex(indexPath.row)
//        }
//        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: {
            (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
            if let imageToShare = UIImage (named: self.restaurants[indexPath.row].image) {
                let activityAcontroller = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.presentViewController(activityAcontroller, animated: true, completion: nil)
            }
        })
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {
            (Action, indexPath) -> Void in
            // Delete the row from the data source
            self.restaurants.removeAtIndex(indexPath.row)
        })
        
        
        // customize button colors
        // shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        // deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203/0/255.0, alpha: 1.0)
        shareAction.backgroundColor = UIColor.blueColor()
        deleteAction.backgroundColor = UIColor.redColor()

        return[deleteAction, shareAction]
    }
    
    
    // MARK: - Table view delegates
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        // Create an option menu as an action sheet
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .ActionSheet)
//        
//        // Add actions to the menu
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//        
//        let callActionHandler = { (action:UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet", preferredStyle: .Alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertMessage, animated: true, completion: nil)
//        }
//        
//        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .Default, handler: callActionHandler)
//        optionMenu.addAction(callAction)
//
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let title = cell?.accessoryType != .Checkmark ? "I've been here" : "I've not been here"
//
//        let isVisitedAction = UIAlertAction(title: title, style: .Default, handler: {
//            (action: UIAlertAction!) -> Void in
//            
//            if (cell?.accessoryType != .Checkmark) {
//                cell?.accessoryType = .Checkmark
//                self.restaurants[indexPath.row].isVisited = true
//            } else {
//                cell?.accessoryType = .None
//                self.restaurants[indexPath.row].isVisited = false
//            }
//            
//        })
//        optionMenu.addAction(isVisitedAction)
//        
//        
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
    
    
    // MARK: - Public API
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
