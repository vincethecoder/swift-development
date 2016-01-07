//
//  HistoryHelper.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/20/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit
import SQLite

class HistoryHelper: DataHelperProtocol {
    
    static let searchId = Expression<Int64>("id")
    static let keyword = Expression<String?>("keyword")
    static let location = Expression<String?>("location")
    static let state = Expression<String?>("state")
    static let timestamp = Expression<String?>("timestamp")

    typealias T = History
    static let table = Table("history")
    static var tableCreated: Bool {
        get {
            return true == createTable()
        }
    }

    static var db: Connection {
        get {
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            
            // if you don't want to handle error you can force it with try! keyword.
            // As with other keywords that ends ! this is a risky operation.
            // If there is an error your program will crash.
            return try! Connection("\(path)/hbjob.sqlite")
        }
    }
    
    static func createTable() -> Bool {
        do {
            let sql = table.create(temporary: false, ifNotExists: true, block: {
                t in
                t.column(searchId, primaryKey: true)
                t.column(keyword, unique: true)
                t.column(location)
                t.column(state)
                t.column(timestamp)
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
            let insert = table.insert(keyword <- item.keyword, location <- item.location, state <- item.state, timestamp <- item.timestamp)
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
        if tableCreated {
            do {
                if let searchKeyword = item.keyword {
                    let record = table.filter(keyword == searchKeyword)
                    try db.run(record.delete())
                    return true
                }
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
        }
        return false
    }
    
    static func findAll() -> [T]? {
        var records: [T] = []
        if tableCreated {
            for h in db.prepare(table.order(searchId.desc)) {
                let historyRecord = History(searchId: h.get(searchId), keyword: h.get(keyword)!, location: h.get(location)!, state: h.get(state)!, timestamp: h.get(timestamp)!)
                records.append(historyRecord)
            }
        }
        
        return records
    }
    
    static func find(item: T) -> T? {
        let query = table.filter(keyword == item.keyword)
        var result: T?
        if tableCreated {
            if let item = db.pluck(query) {
                result = History(searchId: item[searchId], keyword: item[keyword]!, location: item[location]!, state: item[state]!, timestamp: item[timestamp]!)
            }
        }
        return result
    }

}