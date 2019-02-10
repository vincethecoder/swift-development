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
    var results: [Any] = [] {
        didSet {
            guard results.count > 0 else { return }

            let unsortedJobs = results
            jobListings = []
            for unsortedjob in unsortedJobs {
                if let jobs = unsortedjob as? NSArray {
                    for job in jobs {
                        if let diceJob = job as? DiceJobDetail {
                            
                            // Jobs in DiceJob Listings
                            let h1bjob = H1BJob(title: diceJob.jobTitle!, company: diceJob.company!, location: diceJob.location!, date: diceJob.postdate!, detail: diceJob)
                            self.jobListings.append(h1bjob)
                            
                        } else if let cbJob = job as? CBJobDetail {
                            
                            // Jobs in CareerBuilder Listings
                            let company = nil != cbJob.company ? cbJob.company! : ""
                            let h1bjob = H1BJob(title: cbJob.jobTitle!, company: company, location: cbJob.location!, date: cbJob.postedDate!, detail: cbJob)
                            if let _ = cbJob.descriptionTeaser, cbJob.descriptionTeaser?.isValidSponsoredJob == true && cbJob.h1BEligible == true {
                                self.jobListings.append(h1bjob)
                            }
                        } else if let linkupJob = job as? LinkupJobDetail {
                            
                            // Jobs in Linkup Listings
                            let h1bjob = H1BJob(title: linkupJob.job_title!, company: linkupJob.job_company!, location: linkupJob.job_location!, date: linkupJob.job_date_posted, detail: linkupJob)
                            if let description = linkupJob.job_description, description.isValidSponsoredJob {
                                self.jobListings.append(h1bjob)
                            }
                        } else if let indeedJob = job as? IndeedJobDetail {
                            
                            // Jobs in Indeed Listings
                            let h1bjob = H1BJob(title: indeedJob.jobtitle!, company: indeedJob.company!, location: indeedJob.formattedLocation!, date: indeedJob.datePosted, detail: indeedJob)
                            if indeedJob.expired?.boolValue == false && indeedJob.snippet?.isValidSponsoredJob == true {
                                self.jobListings.append(h1bjob)
                            }
                        }
                    }
                }
            }
            
            self.jobListings.sort { lhs, rhs in
                return lhs.postdate.compare(rhs.postdate as Date) == .orderedDescending
            }
        }
    }

    func getJobs(completion: @escaping (_ success: Bool, _ result: NSArray?, _ joblistings: [H1BJob]?, _ error: Error?) -> ()) {
        
        // Job Search: Dice, CareerBuilder, Linkup, Indeed Search Boards
        var searchKeywords = ""
        if let _ = keywords {
            searchKeywords = keywords
        }
        let dice = JobUtils(category: .Dice, search: searchKeywords)
        let diceURL = NSURL(string: dice.requestURL)
        getJobsForUrl(url: diceURL!, jobCategory: .Dice) { (status, result, joblistings, error) -> () in
            
            // CareerBuilder Job Search
            let cb = JobUtils(category: .CareerBuilder, search: searchKeywords)
            let cbURL = NSURL(string: cb.requestURL)
            self.getJobsForUrl(url: cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error) -> () in
                
                // Linkup Job Search
                let linkup = JobUtils(category: .LinkUp, search: searchKeywords)
                let linkupURL = NSURL(string: linkup.requestURL)
                self.getJobsForUrl(url: linkupURL!, jobCategory: .LinkUp, completion: { (success, result, joblistings, error) -> () in
                    
                    // Indeed Job Search
                    let indeed = JobUtils(category: .Indeed, search: searchKeywords)
                    let indeedURL = NSURL(string: indeed.requestURL)
                    self.getJobsForUrl(url: indeedURL!, jobCategory: .Indeed, completion: { (success, result, joblistings, error) -> () in
                       
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
    
    func getJobsForUrl(url: NSURL, jobCategory: JobCategory,
                       completion: @escaping (_ success: Bool, _ result: NSArray?, _ joblistings: [H1BJob]?, _ error: Error?) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: url as URL) {
            (data, response, error) -> Void in

            if let _ = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject] {
                        
                        if jobCategory == .Dice {
                            // Dice Job Search
                            let diceJobs = DiceJob()
                            diceJobs.jobData = jsonResult
                            self.results.append(diceJobs.jobListings)
                        } else if jobCategory == .CareerBuilder {
                            // CareerBuilder Job Search
                            var cbJobs = CBJob()
                            cbJobs.jobData = jsonResult
                            self.results.append(cbJobs.jobListings)
                        } else if jobCategory == JobCategory.LinkUp {
                            // Linkup Job Search
                            var linkupJobs = LinkupJob()
                            linkupJobs.jobData = jsonResult
                            self.results.append(linkupJobs.jobListings)
                        } else if jobCategory == JobCategory.Indeed {
                            // Indeed Job Search
                            var indeedJobs = IndeedJob()
                            indeedJobs.jobData = jsonResult
                            self.results.append(indeedJobs.jobListings)
                        }
                        completion(true, self.results as NSArray, self.jobListings, nil)
                    }
                } catch let error as NSError {
                    print("\(jobCategory.rawValue): \(error.localizedDescription)")
                    if error.code == 3840 { // Restricted Network - Need to change wi-fi connection
                        completion(false, nil, nil, error)
                    }
                }
            } else {
                completion(false, nil, nil, error!)
            }
        }
        task.resume()
    }

}

