//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/28/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    enum RestaurantTableIndex: Int {
        case RestaurantName = 0
        case RestaurantType
        case RestaurantLocation
        case RestaurantPhoneNumber
        case RestaurnatVisited
    }
    
    var restaurant:Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(named: restaurant.image)
        
        tableview.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableview.tableFooterView = UIView(frame: CGRectZero)
        tableview.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)

        title = restaurant.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        
        // Configure the cell ...
        if let index = RestaurantTableIndex(rawValue: indexPath.row) {
            switch index {
            case .RestaurantName:
                cell.fieldLabel.text = "Name"
                cell.valueLabel.text = restaurant.name
            case .RestaurantType:
                cell.fieldLabel.text = "Type"
                cell.valueLabel.text = restaurant.type
            case .RestaurantLocation:
                cell.fieldLabel.text = "Location"
                cell.valueLabel.text = restaurant.location
            case .RestaurantPhoneNumber:
                cell.fieldLabel.text = "Phone"
                cell.valueLabel.text = restaurant.phone
            case .RestaurnatVisited:
                cell.fieldLabel.text = "Been here"
                cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before" : "No"
            }
        } else {
            // Default Case
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
}
