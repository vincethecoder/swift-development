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
    var jobListings: [H1BJob] = [H1BJob]()
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
//                            let company = nil != cbJob.company ? cbJob.company! : ""
//                            let h1bjob = H1BJob(title: cbJob.jobTitle!, company: company, location: cbJob.location!, date: cbJob.postedDate!, detail: cbJob)
//                            if let _ = cbJob.descriptionTeaser, cbJob.descriptionTeaser?.isValidSponsoredJob() == true && cbJob.h1BEligible() == true {
//                                self.jobListings.append(h1bjob)
//                            }
                        } else if let linkupJob = job as? LinkupJobDetail {
                            
                            // Jobs in Linkup Listings
                            let h1bjob = H1BJob(title: linkupJob.job_title!, company: linkupJob.job_company!, location: linkupJob.job_location!, date: linkupJob.job_date_posted!, detail: linkupJob)
                            if linkupJob.description.isValidSponsoredJob() {
                                self.jobListings.append(h1bjob)
                            }
                        } else if let indeedJob = job as? IndeedJobDetail {
                            
                            // Jobs in Indeed Listings
                            let h1bjob = H1BJob(title: indeedJob.jobtitle!, company: indeedJob.company!, location: indeedJob.formattedLocation!, date: indeedJob.datePosted!, detail: indeedJob)
                            if indeedJob.expired?.boolValue == false && indeedJob.snippet?.isValidSponsoredJob() == true {
                                self.jobListings.append(h1bjob)
                            }
                        }
                    }
                }
            }
            self.jobListings.sort {
                $0.postdate.compare($1.postdate as Date) == .orderedDescending
            }
        }
    }

    func getJobs(completion: @escaping (_ success: Bool, _ result: Array<Any>?, _ joblistings: [H1BJob]?, _ error: NSError?) -> ()) {
        
        // Job Search: Dice, CareerBuilder, Linkup, Indeed Search Boards
        var searchKeywords = ""
        if let _ = keywords {
            searchKeywords = keywords
        }
        
        // CareerBuilder Job Search
        let cb = JobUtils(category: .CareerBuilder, search: searchKeywords)
        let cbURL = NSURL(string: cb.requestURL)
        self.getJobsForUrl(cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error)  in
            completion(status, result, joblistings, error)
        }
        // CareerBuilder Completion Block
        
        
        
//        let dice = JobUtils(category: .Dice, search: searchKeywords)
//        let diceURL = NSURL(string: dice.requestURL)
//        getJobsForUrl(diceURL!, jobCategory: .Dice) { (status, result, joblistings, error) in
//            
//            // CareerBuilder Job Search
//            let cb = JobUtils(category: .CareerBuilder, search: searchKeywords)
//            let cbURL = NSURL(string: cb.requestURL)
//            self.getJobsForUrl(cbURL!, jobCategory: .CareerBuilder) { (status, result, joblistings, error) -> () in
//                
//                // Linkup Job Search
//                let linkup = JobUtils(category: .LinkUp, search: searchKeywords)
//                let linkupURL = NSURL(string: linkup.requestURL)
//                self.getJobsForUrl(linkupURL!, jobCategory: .LinkUp, completion: { (success, result, joblistings, error) -> () in
//                    
//                    // Indeed Job Search
//                    let indeed = JobUtils(category: .Indeed, search: searchKeywords)
//                    let indeedURL = NSURL(string: indeed.requestURL)
//                    self.getJobsForUrl(indeedURL!, jobCategory: .Indeed, completion: { (success, result, joblistings, error) -> () in
//                       
//                        // Indeed Completion Block
//                        completion(status, result, joblistings, error)
//                    })
//                    // Linkup Completion Block
//                    // completion(success: status, result: result, joblistings: joblistings, error: error)
//                })
//                // CareerBuilder Completion Block
//                // completion(success: status, result: result, joblistings: joblistings, error: error)
//            }
//            // Dice Completion Block
//            // completion(success: status, result: result, joblistings: joblistings, error: error)
//        }
    }
    
    func getJobsForUrl(_ url: NSURL, jobCategory: JobCategory,
                       completion: @escaping (_ success: Bool, _ result: [Any]?, _ joblistings: [H1BJob]?, _ error: NSError?) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: url as URL) { (data, response, error) in
            
            if let jsonData = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary {
                        
                        if jobCategory == .Dice {
                            // Dice Job Search
                            let diceJobs = DiceJob()
                            diceJobs.jobData = jsonResult as! [String : AnyObject]
                            self.results.append(diceJobs.jobListings)
                            
                        } else if jobCategory == .CareerBuilder {
                            // CareerBuilder Job Search
                            if let jsonData = data {
                                let jobs: Decodable = try? JSONDecoder().decode(CBJob.self, from: jsonData)
                                if let cbJobs = jobs as? CBJob, let responseDict = cbJobs.responseJobSearch,
                                    let jobSearchResult = responseDict["Results"] as? [String: Any],
                                    let rootObjects = jobSearchResult["JobSearchResult"] as? [Any] {
                                        for rootObject in rootObjects {
                                            if let dict = rootObject as? [String:Any] {
                                                let currentJob = CBJobDetail(dict: dict)
                                                self.results.append(currentJob)
                                                
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                                var jobPostDate = Date()
                                                if let date = currentJob.postedDate, let postDate = dateFormatter.date(from: date) {
                                                   jobPostDate = postDate
                                                }
                                                self.jobListings.append(H1BJob(title: currentJob.jobTitle ?? "", company: "", location: currentJob.location ?? "", date: jobPostDate, detail: currentJob))
                                            }
                                        }
                                }
                            }
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
                        completion(true, self.results, self.jobListings, nil)
                    }
                } catch let error as NSError {
                    print("\(jobCategory.rawValue): \(error.localizedDescription)")
                    if error.code == 3840 { // Restricted Network - Need to change wi-fi connection
                        completion(false, nil, nil, error)
                    }
                }
            } else {
                completion(false, nil, nil, error as NSError?)
            }
        }
        task.resume()
    }

}

