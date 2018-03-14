//
//  WorldTendency.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class WorldTendency: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the WorldTendency
    var wb1: UInt32
    var lr1: UInt32
    var wb2: UInt32
    var lr2: UInt32
    var wb3: UInt32
    var lr3: UInt32
    var wb4: UInt32
    var lr4: UInt32
    var wb5: UInt32
    var lr5: UInt32
    var wb6: UInt32
    var lr6: UInt32
    var wb7: UInt32
    var lr7: UInt32
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let wb1 = "wb1"
        static let lr1 = "lr1"
        static let wb2 = "wb2"
        static let lr2 = "lr2"
        static let wb3 = "wb3"
        static let lr3 = "lr3"
        static let wb4 = "wb4"
        static let lr4 = "lr4"
        static let wb5 = "wb5"
        static let lr5 = "lr5"
        static let wb6 = "wb6"
        static let lr6 = "lr6"
        static let wb7 = "wb7"
        static let lr7 = "lr7"
    }
    
    /// Creates a new WorldTendency
    init(wb1: UInt32,
         lr1: UInt32,
         wb2: UInt32,
         lr2: UInt32,
         wb3: UInt32,
         lr3: UInt32,
         wb4: UInt32,
         lr4: UInt32,
         wb5: UInt32,
         lr5: UInt32,
         wb6: UInt32,
         lr6: UInt32,
         wb7: UInt32,
         lr7: UInt32) {
        self.wb1 = wb1
        self.lr1 = lr1
        self.wb2 = wb2
        self.lr2 = lr2
        self.wb3 = wb3
        self.lr3 = lr3
        self.wb4 = wb4
        self.lr4 = lr4
        self.wb5 = wb5
        self.lr5 = lr5
        self.wb6 = wb6
        self.lr6 = lr6
        self.wb7 = wb7
        self.lr7 = lr7
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the WorldTendency from the
    /// database row
    init(row: Row) throws {
        wb1 = try row.get(WorldTendency.Keys.wb1)
        lr1 = try row.get(WorldTendency.Keys.lr1)
        wb2 = try row.get(WorldTendency.Keys.wb2)
        lr2 = try row.get(WorldTendency.Keys.lr2)
        wb3 = try row.get(WorldTendency.Keys.wb3)
        lr3 = try row.get(WorldTendency.Keys.lr3)
        wb4 = try row.get(WorldTendency.Keys.wb4)
        lr4 = try row.get(WorldTendency.Keys.lr4)
        wb5 = try row.get(WorldTendency.Keys.wb5)
        lr5 = try row.get(WorldTendency.Keys.lr5)
        wb6 = try row.get(WorldTendency.Keys.wb6)
        lr6 = try row.get(WorldTendency.Keys.lr6)
        wb7 = try row.get(WorldTendency.Keys.wb7)
        lr7 = try row.get(WorldTendency.Keys.lr7)
    }
    
    // Serializes the WorldTendency to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(WorldTendency.Keys.wb1, wb1)
        try row.set(WorldTendency.Keys.lr1, lr1)
        try row.set(WorldTendency.Keys.wb2, wb2)
        try row.set(WorldTendency.Keys.lr2, lr2)
        try row.set(WorldTendency.Keys.wb3, wb3)
        try row.set(WorldTendency.Keys.lr3, lr3)
        try row.set(WorldTendency.Keys.wb4, wb4)
        try row.set(WorldTendency.Keys.lr4, lr4)
        try row.set(WorldTendency.Keys.wb5, wb5)
        try row.set(WorldTendency.Keys.lr5, lr5)
        try row.set(WorldTendency.Keys.wb6, wb6)
        try row.set(WorldTendency.Keys.lr6, lr6)
        try row.set(WorldTendency.Keys.wb7, wb7)
        try row.set(WorldTendency.Keys.lr7, lr7)
        return row
    }
}

// MARK: Fluent Preparation

extension WorldTendency: Preparation {
    /// Prepares a table/collection in the database
    /// for storing WorldTendencys
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(WorldTendency.Keys.wb1)
            builder.int(WorldTendency.Keys.lr1)
            builder.int(WorldTendency.Keys.wb2)
            builder.int(WorldTendency.Keys.lr2)
            builder.int(WorldTendency.Keys.wb3)
            builder.int(WorldTendency.Keys.lr3)
            builder.int(WorldTendency.Keys.wb4)
            builder.int(WorldTendency.Keys.lr4)
            builder.int(WorldTendency.Keys.wb5)
            builder.int(WorldTendency.Keys.lr5)
            builder.int(WorldTendency.Keys.wb6)
            builder.int(WorldTendency.Keys.lr6)
            builder.int(WorldTendency.Keys.wb7)
            builder.int(WorldTendency.Keys.lr7)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new WorldTendency (POST /WorldTendencys)
//     - Fetching a WorldTendency (GET /WorldTendencys, GET /WorldTendencys/:id)
//
extension WorldTendency: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            wb1: try json.get(WorldTendency.Keys.wb1),
            lr1: try json.get(WorldTendency.Keys.lr1),
            wb2: try json.get(WorldTendency.Keys.wb2),
            lr2: try json.get(WorldTendency.Keys.lr2),
            wb3: try json.get(WorldTendency.Keys.wb3),
            lr3: try json.get(WorldTendency.Keys.lr3),
            wb4: try json.get(WorldTendency.Keys.wb4),
            lr4: try json.get(WorldTendency.Keys.lr4),
            wb5: try json.get(WorldTendency.Keys.wb5),
            lr5: try json.get(WorldTendency.Keys.lr5),
            wb6: try json.get(WorldTendency.Keys.wb6),
            lr6: try json.get(WorldTendency.Keys.lr6),
            wb7: try json.get(WorldTendency.Keys.wb7),
            lr7: try json.get(WorldTendency.Keys.lr7)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(WorldTendency.Keys.id, id)
        try json.set(WorldTendency.Keys.wb1, wb1)
        try json.set(WorldTendency.Keys.lr1, lr1)
        try json.set(WorldTendency.Keys.wb2, wb2)
        try json.set(WorldTendency.Keys.lr2, lr2)
        try json.set(WorldTendency.Keys.wb3, wb3)
        try json.set(WorldTendency.Keys.lr3, lr3)
        try json.set(WorldTendency.Keys.wb4, wb4)
        try json.set(WorldTendency.Keys.lr4, lr4)
        try json.set(WorldTendency.Keys.wb5, wb5)
        try json.set(WorldTendency.Keys.lr5, lr5)
        try json.set(WorldTendency.Keys.wb6, wb6)
        try json.set(WorldTendency.Keys.lr6, lr6)
        try json.set(WorldTendency.Keys.wb7, wb7)
        try json.set(WorldTendency.Keys.lr7, lr7)
        return json
    }
}

// MARK: HTTP

// This allows WorldTendency models to be returned
// directly in route closures
extension WorldTendency: ResponseRepresentable { }

extension WorldTendency: DataConvertible {
    func makeData() -> Data {
        var data = Data()
        data.append(toData(from: self.wb1))
        data.append(toData(from: self.lr1))
        data.append(toData(from: self.wb2))
        data.append(toData(from: self.lr2))
        data.append(toData(from: self.wb3))
        data.append(toData(from: self.lr3))
        data.append(toData(from: self.wb4))
        data.append(toData(from: self.lr4))
        data.append(toData(from: self.wb5))
        data.append(toData(from: self.lr5))
        data.append(toData(from: self.wb6))
        data.append(toData(from: self.lr6))
        data.append(toData(from: self.wb7))
        data.append(toData(from: self.lr7))
        return data
    }
}

extension WorldTendency: DictionaryCreatable {
    convenience init(dictionary: [String: String]) {
        self.init(wb1: UInt32(dictionary[WorldTendency.Keys.wb1]!)!,
                  lr1: UInt32(dictionary[WorldTendency.Keys.lr1]!)!,
                  wb2: UInt32(dictionary[WorldTendency.Keys.wb2]!)!,
                  lr2: UInt32(dictionary[WorldTendency.Keys.lr2]!)!,
                  wb3: UInt32(dictionary[WorldTendency.Keys.wb3]!)!,
                  lr3: UInt32(dictionary[WorldTendency.Keys.lr3]!)!,
                  wb4: UInt32(dictionary[WorldTendency.Keys.wb4]!)!,
                  lr4: UInt32(dictionary[WorldTendency.Keys.lr4]!)!,
                  wb5: UInt32(dictionary[WorldTendency.Keys.wb5]!)!,
                  lr5: UInt32(dictionary[WorldTendency.Keys.lr5]!)!,
                  wb6: UInt32(dictionary[WorldTendency.Keys.wb6]!)!,
                  lr6: UInt32(dictionary[WorldTendency.Keys.lr6]!)!,
                  wb7: UInt32(dictionary[WorldTendency.Keys.wb7]!)!,
                  lr7: UInt32(dictionary[WorldTendency.Keys.lr7]!)!)
    }
}


