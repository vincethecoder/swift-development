//
//  Job.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

class Job: NSObject {
    
    var keywords: String?
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
                            let h1bjob = H1BJob(title: diceJob.jobTitle!, company: diceJob.company!, location: diceJob.location!, date: diceJob.postdate!, detail: diceJob)
                            self.jobListings.append(h1bjob)
                            
                        } else if job.isKindOfClass(CBJobDetail), let cbJob = job as? CBJobDetail {
                            
                            // Jobs in CareerBuilder Listings
                            let company = nil != cbJob.company ? cbJob.company! : ""
                            let h1bjob = H1BJob(title: cbJob.jobTitle!, company: company, location: cbJob.location!, date: cbJob.postedDate!, detail: cbJob)
                            self.jobListings.append(h1bjob)
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
        
        // Dice Job Search
        let dice = JobUtils.init(category: .Dice, search: self.keywords!)
        let diceURL = NSURL(string: dice.requestURL)
        getJobsForUrl(diceURL!, jobCategory: .Dice) { (status, result, joblistings, error) -> () in
            
            // CareerBuilder Job Search
            let cb = JobUtils.init(category: .CareerBuilder, search: self.keywords!)
            let cbURL = NSURL(string: cb.requestURL)
            self.getJobsForUrl(cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error) -> () in
                completion(success: status, result: result, joblistings: joblistings, error: error)
            }
            
            // Dice Completion Block
            //completion(success: status, result: result, error: error)
        }
        
    }
    
    func getJobsForUrl(url: NSURL, jobCategory: JobCategory,
        completion: (success: Bool, result: NSArray?, joblistings: [H1BJob]?, error: NSError?) -> ()) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in

            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    if jobCategory == .Dice {
                        // Dice Job Search
                        let diceJobs = DiceJob()
                        diceJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(diceJobs.jobListings)
                    } else {
                        // CareerBuilder Job Search
                        let cbJobs = CBJob()
                        cbJobs.jobData = jsonResult as! [String : AnyObject]
                        self.results.append(cbJobs.jobListings)
                    }
                    completion(success: true, result: self.results, joblistings: self.jobListings, error: nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(success: false, result: nil, joblistings: nil, error: error)
            }
        }
        task.resume()
    }

}

