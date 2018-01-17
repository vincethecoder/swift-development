//
//  DataHelperProtocol.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/20/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import Foundation

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() -> Bool
    static func insert(item: T) -> Int64
    static func delete(item: T) -> Bool
    static func findAll() -> [T]?
}
