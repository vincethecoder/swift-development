//
//  SQLiteDataStore.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/20/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import Foundation
import SQLite

// Mastering Swift - Create a Data Access Layer with SQLite.swift
// Documentation: http://masteringswift.blogspot.com/2015/06/create-data-access-layer-with.html

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let JobDB: Database
    
    private init() {
        
        var path = "hbjob.sqlite"
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        path = "\(dir)/\(path)"
        print(path)
        
        /*let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        // if you don't want to handle error you can force it with try! keyword.
        // As with other keywords that ends ! this is a risky operation.
        // If there is an error your program will crash.
        return try! Connection("\(path)/hbjob.sqlite")**/
        
        JobDB = Database(path: path)
        
        createTables()
    }
    
    func createTables() {
        HistoryHelper.createTable()
    }
    
    
}