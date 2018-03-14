//
//  ServerSetting.swift
//  App
//
//  Created by Łukasz Przytuła on 14.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class ServerSetting: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the ServerSetting
    var key: String
    var value: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let key = "key"
        static let value = "value"
    }
    
    /// Creates a new ServerSetting
    init(key: String,
         value: String = "") {
        self.key = key
        self.value = value
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the ServerSetting from the
    /// database row
    init(row: Row) throws {
        key = try row.get(ServerSetting.Keys.key)
        value = try row.get(ServerSetting.Keys.value)
    }
    
    // Serializes the ServerSetting to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ServerSetting.Keys.key, key)
        try row.set(ServerSetting.Keys.value, value)
        return row
    }
}

// MARK: Fluent Preparation

extension ServerSetting: Preparation {
    /// Prepares a table/collection in the database
    /// for storing ServerSettings
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(ServerSetting.Keys.key, type: "TEXT", unique: true)
            builder.custom(ServerSetting.Keys.value, type: "TEXT")
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
//     - Creating a new ServerSetting (POST /ServerSettings)
//     - Fetching a ServerSetting (GET /ServerSettings, GET /ServerSettings/:id)
//
extension ServerSetting: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            key: try json.get(ServerSetting.Keys.key),
            value: try json.get(ServerSetting.Keys.value)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ServerSetting.Keys.id, id)
        try json.set(ServerSetting.Keys.key, key)
        try json.set(ServerSetting.Keys.value, value)
        return json
    }
}

// MARK: HTTP

// This allows RequestLog models to be returned
// directly in route closures
extension ServerSetting: ResponseRepresentable { }

// MARK: Update

// This allows the ServerSetting model to be updated
// dynamically by the request.
extension ServerSetting: Updateable {
    // Updateable keys are called when `serverSetting.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<ServerSetting>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(ServerSetting.Keys.value, String.self) { serverSetting, value in
                serverSetting.value = value
            }
        ]
    }
}
