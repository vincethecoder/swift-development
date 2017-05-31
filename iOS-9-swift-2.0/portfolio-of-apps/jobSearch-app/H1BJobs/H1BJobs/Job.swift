//
//  Job.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class Job: NSObject {
    
    var keywords: String!
    var jobListings: [H1BJob] = []
    var results: [AnyObject] = [] {
        didSet {
            guard results.count > 0 else { return }

            let unsortedJobs = results
            jobListings = []
            for unsortedjob in unsortedJobs {
                if unsortedjob is NSArray, let jobs = unsortedjob as? NSArray {
                    for job in jobs {
                        if (job as AnyObject) is DiceJobDetail, let diceJob = job as? DiceJobDetail {
                            
                            // Jobs in DiceJob Listings
                            if diceJob.jobTitle.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: diceJob.jobTitle, company: diceJob.company, location: diceJob.location, date: diceJob.postdate!, detail: diceJob)
                                self.jobListings.append(h1bjob)
                            }
                        } else if let cbJob = job as? CBJobDetail {
                            
                            // Jobs in CareerBuilder Listings
                            if cbJob.jobTitle.matchedKeyword(keywords) {
                                let company = nil != cbJob.company ? cbJob.company! : ""
                                let h1bjob = H1BJob(title: cbJob.jobTitle, company: company, location: cbJob.location, date: cbJob.postedDate, detail: cbJob)
                                if let _ = cbJob.descriptionTeaser, cbJob.descriptionTeaser?.isValidSponsoredJob() == true && cbJob.h1BEligible() == true {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        } else if let linkupJob = job as? LinkupJobDetail {
                            
                            // Jobs in Linkup Listings
                            if linkupJob.job_title.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: linkupJob.job_title, company: linkupJob.job_company, location: linkupJob.job_location, date: linkupJob.job_date_posted, detail: linkupJob)
                                if linkupJob.description.isValidSponsoredJob() {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        } else if let indeedJob = job as? IndeedJobDetail {
                            
                            // Jobs in Indeed Listings
                            if indeedJob.jobtitle.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: indeedJob.jobtitle, company: indeedJob.company, location: indeedJob.formattedLocation!, date: indeedJob.datePosted, detail: indeedJob)
                                if indeedJob.expired?.boolValue == false && indeedJob.snippet?.isValidSponsoredJob() == true {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        }
                    }
                }
            }
             self.jobListings.sort {
                if let obj1 = $0.postdate, let obj2 = $1.postdate {
                    return obj1.compare(obj2 as Date) == .orderedDescending
                }
                return false
            }
        }
    }

    func getJobs(_ completion: @escaping (_ success: Bool, _ result: NSArray?, _ joblistings: [H1BJob]?, _ error: NSError?) -> ()) {
        
        // Job Search: Dice, CareerBuilder, Linkup, Indeed Search Boards
        let searchKeywords = keywords ?? ""
        let dice = JobUtils(category: .Dice, search: searchKeywords)
        let diceURL = URL(string: dice.requestURL)
        getJobsForUrl(diceURL!, jobCategory: .Dice) { (status, result, joblistings, error) -> () in
            
            // CareerBuilder Job Search
            let cb = JobUtils(category: .CareerBuilder, search: searchKeywords)
            let cbURL = URL(string: cb.requestURL)
            self.getJobsForUrl(cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error) -> () in
                
                // Linkup Job Search
                let linkup = JobUtils(category: .LinkUp, search: searchKeywords)
                let linkupURL = URL(string: linkup.requestURL)
                self.getJobsForUrl(linkupURL!, jobCategory: .LinkUp, completion: { (success, result, joblistings, error) -> () in
                    
                    // Indeed Job Search
                    let indeed = JobUtils(category: .Indeed, search: searchKeywords)
                    let indeedURL = URL(string: indeed.requestURL)
                    self.getJobsForUrl(indeedURL!, jobCategory: .Indeed, completion: { (success, result, joblistings, error) -> () in
                       
                        // Indeed Completion Block
                        completion(status, result, joblistings, error)
                    })
                    // Linkup Completion Block
                    // completion(success: status, result: result, joblistings: joblistings, error: error)
                })
                // CareerBuilder Completion Block
                // completion(success: status, result: result, joblistings: joblistings, error: error)
            }
            // Dice Completion Block
            // completion(success: status, result: result, joblistings: joblistings, error: error)
        }
    }
    
    func getJobsForUrl(_ url: URL, jobCategory: JobCategory,
        completion: @escaping (_ success: Bool, _ result: NSArray?, _ joblistings: [H1BJob]?, _ error: NSError?) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in

            guard data != nil else {
                completion(false, nil, nil, error as! NSError)
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if jobCategory == .Dice {
                        // Dice Job Search
                        let diceJobs = DiceJob()
                        diceJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(diceJobs.jobListings as AnyObject)
                    } else if jobCategory == .CareerBuilder {
                        // CareerBuilder Job Search
                        let cbJobs = CBJob()
                        cbJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(cbJobs.jobListings as AnyObject)
                    } else if jobCategory == JobCategory.LinkUp {
                        // Linkup Job Search
                        let linkupJobs = LinkupJob()
                        linkupJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(linkupJobs.jobListings as AnyObject)
                    } else if jobCategory == JobCategory.Indeed {
                        // Indeed Job Search
                        let indeedJobs = IndeedJob()
                        indeedJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(indeedJobs.jobListings as AnyObject)
                    }
                    completion(true, self.results as NSArray, self.jobListings, nil)
                }
            } catch let error as NSError {
                print("\(jobCategory.rawValue): \(error.localizedDescription)")
                if error.code == 3840 { // Restricted Network - Need to change wi-fi connection
                    completion(false, nil, nil, error)
                }
            }

        }) 
        task.resume()
    }

}

