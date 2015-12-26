//
//  FavoriteHelper.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit
import SQLite

class FavoriteHelper: DataHelperProtocol {
    
    static let favoriteId = Expression<Int64>("id")
    static let jobTitle = Expression<String?>("jobtitle")
    static let company = Expression<String?>("company")
    static let jobId = Expression<String?>("jobid")
    static let savedTimestamp = Expression<String?>("timestamp")
    static let source = Expression<String?>("source")
    
    typealias T = Favorite
    static let table = Table("favorite")

    static var db: Connection {
        get {
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            
            // if you don't want to handle error you can force it with try! keyword.
            // As with other keywords that ends ! this is a risky operation.
            // If there is an error your program will crash.
            return try! Connection("\(path)/hbjob.sqlite")
        }
    }
    
    static var tableCreated: Bool {
        get {
            return true == createTable()
        }
    }
    
    static func createTable() -> Bool {
        do {
            let sql = table.create(temporary: false, ifNotExists: true, block: {
                t in
                t.column(favoriteId, primaryKey: true)
                t.column(jobId, unique: true)
                t.column(jobTitle)
                t.column(company)
                t.column(savedTimestamp)
                t.column(source)
            })
            try db.run(sql)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return false
        }
        return true
    }
    
    static func insert(item: T) -> Int64 {
        if tableCreated {
            let insert = table.insert(jobId <- item.jobId, jobTitle <- item.jobTitle, company <- item.company, savedTimestamp <- item.savedTimestamp, source <- item.source)
            do {
                let rowId = try db.run(insert)
                return rowId
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
        }
        
        return -1
    }

    static func delete(item: T) -> Bool {
        do {
            if let id = item.favoriteId {
                let record = table.filter(favoriteId == id)
                try db.run(record.delete())
                return true
            }
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        return false
    }
    
    static func findAll() -> [T]? {
        var records: [T] = []
        if tableCreated {
            for f in db.prepare(table) {
                let favoriteRecord = Favorite(favoriteId: f.get(favoriteId), jobTitle: f.get(jobTitle)!, company: f.get(company)!, jobId: f.get(jobId)!, savedTimestamp: f.get(savedTimestamp)!, source: f.get(source)!)
                records.append(favoriteRecord)
            }
        }
        return records
    }
    
    static func find(id: Int64) -> T? {
        let query = table.filter(favoriteId == id)
        var result: T?
        if let item = db.pluck(query) {
            result = Favorite(favoriteId: item[favoriteId], jobTitle: item[jobId]!, company: item[company]!, jobId: item[jobId]!, savedTimestamp: item[savedTimestamp]!, source: item[source]!)
        }
        return result
    }
    
    static func count() -> Int {
        if tableCreated {
            let count = db.scalar(table.count)
            return count
        }
        return -1
    }

}
