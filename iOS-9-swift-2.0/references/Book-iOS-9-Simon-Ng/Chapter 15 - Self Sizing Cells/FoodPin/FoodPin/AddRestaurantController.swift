//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Kobe Sam on 9/30/15.
//  Copyright © 2015 KobeScript. All rights reserved.
//

import UIKit

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!
    
    var isVisited: Bool?
    
    enum AddRestaurantTableRows: Int {
        case AddRestaurantImage = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isVisited = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let tableIndex = AddRestaurantTableRows(rawValue: indexPath.row) {
            if tableIndex == .AddRestaurantImage {
                if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .PhotoLibrary
                    
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        // Add constraints
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: imageView.superview, attribute: .Leading, multiplier: 1, constant: 0)
        leadingConstraint.active = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: imageView.superview, attribute: .Trailing, multiplier: 1, constant: 0)
        trailingConstraint.active = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1, constant: 0)
        topConstraint.active = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        bottomConstraint.active = true

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        if let name = nameTextField?.text {
            print("Name: Optional (\"\(name)\")")
        }
        
        if let type = typeTextField?.text {
            print("Type: Optional (\"\(type)\")")
        }
        
        if let location = typeTextField?.text {
            print("Location: Optional (\"\(location)\")")
        }
        
        if isVisited == true {
            print("Have you been here: true")
        } else {
            print("Have you been here: false")
        }
        
        
        performSegueWithIdentifier("unwindToHomeScreen", sender: self)
        
    }
    
    @IBAction func toggleBeenHereButton(sender: UIButton) {
        // Yes button clicked
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = .redColor()
            noButton.backgroundColor = .grayColor()
        } else if sender == noButton {
            isVisited = false
            yesButton.backgroundColor = .grayColor()
            noButton.backgroundColor = .redColor()
        }
    }

}
