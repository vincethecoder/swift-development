//
//  FavoriteTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var favoriteList: [Favorite] = []
    let cellIdentifier = "favoriteCell"
    let webViewSegueIdentifier = "favJobHyperLink"
    var favoriteDefaultView: ErrorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Search Results Page Title
        title = "Saved Jobs"
        
        // Preserves selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let inset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.contentInset = inset
        
        // Apply a blurring effect to the background image view
        tableView.backgroundView = UIImageView(image: UIImage(named: "city_skyline_ny"))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height * 2)
        tableView.backgroundView!.addSubview(blurEffectView)
        
        // Add "No Favorite Transcript Available" View
        addDefaultView()

    }
    
    func addDefaultView() {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        
        favoriteDefaultView = ErrorView(frame: frame, title: "It's pretty quiet around here",
            text: "You'll see a list of favorite jobs \nwhen you start a search and save the jobs",
            image: UIImage(named: "like_filled_gray")!)
        favoriteDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(favoriteDefaultView)
        tableView.bringSubview(toFront: favoriteDefaultView)
        let widthConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewWidth)
        favoriteDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewHeight)
        favoriteDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: favoriteDefaultView, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: -35)
        tableView.addConstraint(yCenterConstraint)
        
        favoriteDefaultView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favoriteList = FavoriteHelper.findAll() {
            self.favoriteList.removeAll()
            for favorite in favoriteList {
                self.favoriteList.append(favorite)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }

        if self.favoriteList.count > 0 {
            favoriteDefaultView.isHidden = true
        } else {
            favoriteDefaultView.isHidden = false
        }
        
        updateFavoriteTabBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultsTableViewCell

        cell.backgroundColor = .clear
        
        let row = indexPath.row
        let favoriteData = favoriteList[row]
        
        cell.jobTitle.text = favoriteData.jobTitle?.capitalized
        cell.jobCompany.text = favoriteData.company
        cell.jobPostDate.text = "Saved: \(favoriteData.savedTimestamp!)"
        
        cell.imageView?.image = UIImage(data: favoriteData.image as Data)!
        cell.imageView?.isHidden = false
        cell.textLabel?.text = ""
        cell.saveButton.tintColor = .red
        cell.jobWebUrl = favoriteData.jobUrl
        cell.saveButton.isHidden = false
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = indexPath.row
            _ = FavoriteHelper.delete(item: favoriteList[row])
            guard favoriteList.count > row else { return }
            favoriteList.remove(at: row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
            if favoriteList.count == 0 {
                favoriteDefaultView.isHidden = false
            } else {
                favoriteDefaultView.isHidden = true
            }
            
            updateFavoriteTabBadge()
        }
    }
    
    func updateFavoriteTabBadge() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let favoriteTab = tabArray?.object(at: 1) as! UITabBarItem
        let favoriteCount = FavoriteHelper.count()
        favoriteTab.badgeValue = favoriteCount > 0 ? "\(favoriteCount)" : nil
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        
        if let senderView = sender as? UITableViewCell {
            let center = senderView.center
            let rootViewPoint = senderView.superview?.convert(center, to: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: rootViewPoint!) {
                let webView = segue.destination as? JobWebViewController
                let row = indexPath.row
                let h1bjob = favoriteList[row]
                webView?.jobUrl = h1bjob.jobUrl
                webView?.job = h1bjob
            }
        }
        
    }

}
