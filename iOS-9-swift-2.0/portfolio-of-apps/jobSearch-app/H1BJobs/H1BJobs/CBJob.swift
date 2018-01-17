//
//  CareerBuilderJob.swift
//  H1BJobs
//
//  Created by Kobe Sam on 11/26/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

struct CBJob {
    
    var jobListings = [CBJobDetail]()
    var searchResponse: CBJobResponse?
    var responseJobSearch: [String: Any]?
    var hasResults: Bool {
        return jobListings.count > 0
    }

    enum CodingKeys: String, CodingKey {
        case responseJobSearch = "ResponseJobSearch"
    }
}

extension CBJob: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(responseJobSearch, forKey: .responseJobSearch)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension CBJob: Decodable {
    
    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            responseJobSearch = try values.decode([String: Any].self, forKey: .responseJobSearch)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

