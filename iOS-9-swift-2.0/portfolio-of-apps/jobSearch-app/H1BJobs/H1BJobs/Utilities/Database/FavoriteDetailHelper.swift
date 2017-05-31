//
//  FavoriteDetailHelper.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/25/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit
import SQLite

class FavoriteDetailHelper: DataHelperProtocol {

    static let favoriteId = Expression<Int64>("id")
    static let jobId = Expression<String?>("jobid")
    static let jobLocation = Expression<String?>("location")
    static let locationLat = Expression<String?>("lat")
    static let locationLng = Expression<String?>("lng")
    static let descTeaser = Expression<String?>("teaser")
    static let pay = Expression<String?>("pay")
    static let postDate = Expression<String?>("postdate")
    static let imageUrl = Expression<String?>("imageurl")
    
    typealias T = FavoriteDetail
    static let table = Table("favoriteDetail")
    static var tableCreated: Bool {
        get {
            return true == createTable()
        }
    }
    
    static var db: Connection {
        get {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
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
                t.column(favoriteId, primaryKey: true)
                t.column(jobId, unique: true)
                t.column(jobLocation)
                t.column(locationLat)
                t.column(locationLng)
                t.column(descTeaser)
                t.column(pay)
                t.column(postDate)
                t.column(imageUrl)
            })
            try db.run(sql)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return false
        }
        return true
    }

    static func insert(_ item: T) -> Int64 {
        if tableCreated {
            let insert = table.insert(jobId <- item.jobId, jobLocation <- item.jobLocation, locationLat <- item.locationLat, locationLng <- item.locationLng, descTeaser <- item.descTeaser, pay <- item.pay, postDate <- item.postDate, imageUrl <- item.imageUrl)
            do {
                let rowId = try db.run(insert)
                return rowId
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
        }
        return -1
    }
    
    static func delete(_ item: T) -> Bool {
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
        do {
            let dbTable = try db.prepare(table)
            for f in dbTable {
                let favoriteDetailRecord = FavoriteDetail(favoriteId: f.get(favoriteId), jobId: f.get(jobId)!, jobLocation: f.get(jobLocation)!, locationLat: f.get(locationLat)!, locationLng: f.get(locationLng)!, descTeaser: f.get(descTeaser)!, pay: f.get(pay)!, postDate: f.get(postDate)!, imageUrl: f.get(imageUrl)!)
                records.append(favoriteDetailRecord)
            }
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        return records
    }
    
    static func find(_ id: Int64) -> T? {
        let query = table.filter(favoriteId == id)
        var result: T?
        if let item = try? db.pluck(query), let record = item {
            result = FavoriteDetail(favoriteId: record[favoriteId], jobId: record[jobId]!, jobLocation: record[jobLocation]!, locationLat: record[locationLat]!, locationLng: record[locationLng]!, descTeaser: record[descTeaser]!, pay: record[pay]!, postDate: record[postDate]!, imageUrl: record[imageUrl]!)
        }
        return result
    }
}
