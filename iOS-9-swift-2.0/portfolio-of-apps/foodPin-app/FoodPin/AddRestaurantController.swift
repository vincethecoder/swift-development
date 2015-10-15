//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/28/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView:UIImageView!

    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var phoneNumberTextField:UITextField!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    
    var isVisited = true
    
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
                    
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        leadingConstraint.active = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        trailingConstraint.active = true
                    
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        topConstraint.active = true
                    
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        bottomConstraint.active = true
                    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action methods
    
    @IBAction func save(sender:UIBarButtonItem) {
        let name = nameTextField.text
        let type = typeTextField.text
        let location = locationTextField.text
        let phoneNumber = phoneNumberTextField.text
        
        // Validate input fields
        if name == "" || type == "" || location == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
            restaurant.name = name!
            restaurant.type = type!
            restaurant.location = location!
            restaurant.phoneNumber = phoneNumber!
            
            if let restaurantImage = imageView.image {
                restaurant.image = UIImagePNGRepresentation(restaurantImage)
            }
            restaurant.isVisited = isVisited
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
                return
            }
        }
        
        // Save the record to iCloud
        saveRecordToCloud(restaurant)

        // Dismiss the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toggleBeenHereButton(sender: UIButton) {
        // Yes button clicked
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor.grayColor()
        } else if sender == noButton {
            isVisited = false
            yesButton.backgroundColor = UIColor.grayColor()
            noButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
    
    // MARK: - CloudKit Methods
    
    func saveRecordToCloud(restaurant:Restaurant!) -> Void {
        // Prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phoneNumber, forKey: "phone")
        
        // Resize the image
        let originalImage = UIImage(data: restaurant.image!)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image!, scale:scalingFactor)!
        
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name
        UIImageJPEGRepresentation(scaledImage, 0.8)?.writeToFile(imageFilePath, atomically: true)
        
        // Create image asset for upload
        let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        // Get the Public iCloud Database
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.saveRecord(record, completionHandler:{ (record:CKRecord?, error:NSError?) -> Void in
            // Remove temp file
            do {
                try NSFileManager.defaultManager().removeItemAtPath(imageFilePath)
            } catch {
                print("Failed to save record to the cloud: \(error)")
            }
        })
    }
    
}
