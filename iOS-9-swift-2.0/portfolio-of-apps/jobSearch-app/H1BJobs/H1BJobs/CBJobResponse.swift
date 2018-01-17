//
//  CBJobResponse.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJobResponse {
    
    var errors: Error?
    var TimeResponseSent: String?
    var TimeElapsed: String?
    var totalPages: String?
    var totalCount: String?
    var firstItemIndex: String?
    var lastItemIndex: String?
    var SearchMetaData: [String: Any]?
    var jobListings = [CBJobDetail]()
    var RequestEvidenceID: String?
    var jobSearchResult = [String: Any]()
    
    var results: [String : Any] = [String : Any]() {
        didSet {
//            if let searchReaults = results["JobSearchResult"] as? NSArray {
////                for searhResult in searchReaults {
////                    let dict = searhResult as! [String : Any]
////                    let job = CBJobDetail(dict: dict)
////                    jobListings.append(job)
////                }
//            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case jobSearchResult = "JobSearchResult"
        case results
        case totalCount
        case totalPages
        case firstIndex
        case lastIndex
    }
}

extension CBJobResponse: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(jobSearchResult, forKey: .jobSearchResult)
            try container.encode(results, forKey: .results)
            try container.encode(totalCount, forKey: .totalCount)
            try container.encode(totalPages, forKey: .totalPages)
            try container.encode(firstItemIndex, forKey: .firstIndex)
            try container.encode(lastItemIndex, forKey: .lastIndex)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension CBJobResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.jobSearchResult = try values.decode([String:Any].self, forKey: .jobSearchResult)
            self.results = try values.decode(Dictionary.self, forKey: .results)
            self.totalCount = try values.decode(String.self, forKey: .totalCount)
            self.totalPages = try values.decode(String.self, forKey: .totalPages)
            self.firstItemIndex = try values.decode(String.self, forKey: .firstIndex)
            self.lastItemIndex = try values.decode(String.self, forKey: .lastIndex)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

