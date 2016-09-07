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
    static let jobUrl = Expression<String?>("joburl")
    static let savedTimestamp = Expression<String?>("timestamp")
    static let image = Expression<NSData?>("image")
    
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
                t.column(jobTitle)
                t.column(company)
                t.column(jobUrl)
                t.column(savedTimestamp)
                t.column(image)
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
            let insert = table.insert(jobTitle <- item.jobTitle, company <- item.company, jobUrl <- item.jobUrl,  savedTimestamp <- item.savedTimestamp, image <- item.image)
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
            if tableCreated, let title = item.jobTitle {
                let record = table.filter(jobTitle == title && company == item.company)
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
            do {
                let dbTable = try db.prepare(table)
                for f in dbTable {
                    let favoriteRecord = Favorite(favoriteId: f.get(favoriteId), jobTitle: f.get(jobTitle)!, company: f.get(company)!, jobUrl: f.get(jobUrl)!, savedTimestamp: f.get(savedTimestamp)!, image: f.get(image)!)
                    records.append(favoriteRecord)
                }
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
        }
        return records
    }
    
    static func find(item: T) -> T? {
        let query = table.filter(jobTitle == item.jobTitle && company == item.company)
        var result: T?
        if tableCreated {
            if let item = db.pluck(query) {
                result = Favorite(favoriteId: item[favoriteId], jobTitle: item[jobTitle]!, company: item[company]!, jobUrl: item[jobUrl]!, savedTimestamp: item[savedTimestamp]!, image: item[image]!)
            }
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
