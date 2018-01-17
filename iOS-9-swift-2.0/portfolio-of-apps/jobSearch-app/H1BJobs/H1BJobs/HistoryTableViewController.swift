//
//  HistoryTableViewController.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/14/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var historyList: [History] = []
    let cellIdentifier = "historyCell"
    let resultsSegueIdentifier = "historyResults"
    var historyDefaultView: ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search Results Page Title
        title = "Search History"

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
        
        // Add "No History Transcript Available" View
        addDefaultView()
        
    }
    
    func addDefaultView() {
        let viewHeight: CGFloat = 175
        let viewWidth: CGFloat = 350
        let frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)

        historyDefaultView = ErrorView(frame: frame, title: "It's pretty quiet around here",
                                        text: "You'll begin to see a search history transcript \nwhen you search for jobs",
                                       image: UIImage(named: "clock_filled_gray")!)
        historyDefaultView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(historyDefaultView)
        tableView.bringSubview(toFront: historyDefaultView)
        let widthConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewWidth)
        historyDefaultView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewHeight)
        historyDefaultView.addConstraint(heightConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0)
        tableView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: historyDefaultView, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: -35)
        tableView.addConstraint(yCenterConstraint)
        
        historyDefaultView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let historyList = HistoryHelper.findAll() {
            self.historyList.removeAll()
            for history in historyList {
                self.historyList.append(history)
            }
        }
        
        if self.historyList.count > 0 {
            historyDefaultView.isHidden = true
            tableView.reloadData()
        } else {
            historyDefaultView.isHidden = false
        }
        
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
        return historyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell

        cell.backgroundColor = .clear
        
        let row = indexPath.row
        let historyData = historyList[row]
        var keyword  = "All H1B Jobs"
        if let histKeyword = historyData.keyword, histKeyword.count > 0 {
            keyword = histKeyword.capitalized
        }
        
        cell.historyLocationIcon.isHidden = false
        cell.historySearchIcon.isHidden = false
        cell.historyLocation.isHidden = false
        cell.imageView?.isHidden = false
        cell.jobKeyword.text = "\(keyword)"
        cell.textLabel?.text = ""
        cell.imageView?.image = UIImage(named: "calendar_full")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = indexPath.row
            _ = HistoryHelper.delete(item: historyList[row])
            guard historyList.count > row else { return }
            historyList.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .none)
            
            if historyList.count == 0 {
                historyDefaultView.isHidden = false
            } else {
                historyDefaultView.isHidden = true
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == resultsSegueIdentifier,
        let indexPath = tableView.indexPathForSelectedRow {
            let searchResults = segue.destination as? SearchResultsViewController
            let row = indexPath.row
            let historyData = historyList[row]
            searchResults?.keywords = historyData.keyword
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}
