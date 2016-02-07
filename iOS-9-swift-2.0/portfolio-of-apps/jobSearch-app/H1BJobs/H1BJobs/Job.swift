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
                if unsortedjob.isKindOfClass(NSArray), let jobs = unsortedjob as? NSArray {
                    for job in jobs {
                        if job.isKindOfClass(DiceJobDetail), let diceJob = job as? DiceJobDetail {
                            
                            // Jobs in DiceJob Listings
                            if diceJob.jobTitle.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: diceJob.jobTitle, company: diceJob.company!, location: diceJob.location!, date: diceJob.postdate!, detail: diceJob)
                                self.jobListings.append(h1bjob)
                            }
                        } else if job.isKindOfClass(CBJobDetail), let cbJob = job as? CBJobDetail {
                            
                            // Jobs in CareerBuilder Listings
                            if cbJob.jobTitle.matchedKeyword(keywords) {
                                let company = nil != cbJob.company ? cbJob.company! : ""
                                let h1bjob = H1BJob(title: cbJob.jobTitle, company: company, location: cbJob.location!, date: cbJob.postedDate!, detail: cbJob)
                                if let _ = cbJob.descriptionTeaser where cbJob.descriptionTeaser?.isValidSponsoredJob() == true && cbJob.h1BEligible() == true {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        } else if job.isKindOfClass(LinkupJobDetail), let linkupJob = job as? LinkupJobDetail {
                            
                            // Jobs in Linkup Listings
                            if linkupJob.job_title.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: linkupJob.job_title, company: linkupJob.job_company!, location: linkupJob.job_location!, date: linkupJob.job_date_posted, detail: linkupJob)
                                if linkupJob.description.isValidSponsoredJob() {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        } else if job.isKindOfClass(IndeedJobDetail), let indeedJob = job as? IndeedJobDetail {
                            
                            // Jobs in Indeed Listings
                            if indeedJob.jobtitle.matchedKeyword(keywords) {
                                let h1bjob = H1BJob(title: indeedJob.jobtitle!, company: indeedJob.company!, location: indeedJob.formattedLocation!, date: indeedJob.datePosted, detail: indeedJob)
                                if indeedJob.expired?.boolValue == false && indeedJob.snippet?.isValidSponsoredJob() == true {
                                    self.jobListings.append(h1bjob)
                                }
                            }
                        }
                    }
                }
            }
             self.jobListings.sortInPlace {
                $0.postdate.compare($1.postdate) == .OrderedDescending
            }
        }
    }

    func getJobs(completion: (success: Bool, result: NSArray?, joblistings: [H1BJob]?, error: NSError?) -> ()) {
        
        // Job Search: Dice, CareerBuilder, Linkup, Indeed Search Boards
        var searchKeywords = ""
        if let _ = keywords {
            searchKeywords = keywords
        }
        let dice = JobUtils(category: .Dice, search: searchKeywords)
        let diceURL = NSURL(string: dice.requestURL)
        getJobsForUrl(diceURL!, jobCategory: .Dice) { (status, result, joblistings, error) -> () in
            
            // CareerBuilder Job Search
            let cb = JobUtils(category: .CareerBuilder, search: searchKeywords)
            let cbURL = NSURL(string: cb.requestURL)
            self.getJobsForUrl(cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error) -> () in
                
                // Linkup Job Search
                let linkup = JobUtils(category: .LinkUp, search: searchKeywords)
                let linkupURL = NSURL(string: linkup.requestURL)
                self.getJobsForUrl(linkupURL!, jobCategory: .LinkUp, completion: { (success, result, joblistings, error) -> () in
                    
                    // Indeed Job Search
                    let indeed = JobUtils(category: .Indeed, search: searchKeywords)
                    let indeedURL = NSURL(string: indeed.requestURL)
                    self.getJobsForUrl(indeedURL!, jobCategory: .Indeed, completion: { (success, result, joblistings, error) -> () in
                       
                        // Indeed Completion Block
                        completion(success: status, result: result, joblistings: joblistings, error: error)
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
    
    func getJobsForUrl(url: NSURL, jobCategory: JobCategory,
        completion: (success: Bool, result: NSArray?, joblistings: [H1BJob]?, error: NSError?) -> ()) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in

            if let _ = data {
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        
                        if jobCategory == .Dice {
                            // Dice Job Search
                            let diceJobs = DiceJob()
                            diceJobs.jobData = jsonResult as! [String : AnyObject]
                            self.results.append(diceJobs.jobListings)
                        } else if jobCategory == .CareerBuilder {
                            // CareerBuilder Job Search
                            let cbJobs = CBJob()
                            cbJobs.jobData = jsonResult as! [String : AnyObject]
                            self.results.append(cbJobs.jobListings)
                        } else if jobCategory == JobCategory.LinkUp {
                            // Linkup Job Search
                            let linkupJobs = LinkupJob()
                            linkupJobs.jobData = jsonResult as! [String : AnyObject]
                            self.results.append(linkupJobs.jobListings)
                        } else if jobCategory == JobCategory.Indeed {
                            // Indeed Job Search
                            let indeedJobs = IndeedJob()
                            indeedJobs.jobData = jsonResult as! [String : AnyObject]
                            self.results.append(indeedJobs.jobListings)
                        }
                        completion(success: true, result: self.results, joblistings: self.jobListings, error: nil)
                    }
                } catch let error as NSError {
                    print("\(jobCategory.rawValue): \(error.localizedDescription)")
                    if error.code == 3840 { // Restricted Network - Need to change wi-fi connection
                        completion(success: false, result: nil, joblistings: nil, error: error)
                    }
                }
            } else {
                completion(success: false, result: nil, joblistings: nil, error: error)
            }
        }
        task.resume()
    }

}

