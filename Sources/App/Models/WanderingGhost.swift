//
//  WanderingGhost.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class WanderingGhost: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the WanderingGhost
    var characterID: String
    var ghostBlockID: Int32
    var posx: Float32
    var posy: Float32
    var posz: Float32
    var replayData: String
    var port: Int
    var timestamp: Date
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let characterID = "characterID"
        static let ghostBlockID = "ghostBlockID"
        static let posx = "posx"
        static let posy = "posy"
        static let posz = "posz"
        static let replayData = "replayData"
        static let port = "port"
        static let timestamp = "timestamp"
    }
    
    /// Creates a new WanderingGhost
    init(characterID: String,
         ghostBlockID: Int32,
         posx: Float32,
         posy: Float32,
         posz: Float32,
         replayData: String,
         port: Int = 0,
         timestamp: Date = Date()) {
        self.characterID = characterID
        self.ghostBlockID = ghostBlockID
        self.posx = posx
        self.posy = posy
        self.posz = posz
        self.replayData = replayData
        self.port = port
        self.timestamp = timestamp
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the WanderingGhost from the
    /// database row
    init(row: Row) throws {
        characterID = try row.get(WanderingGhost.Keys.characterID)
        ghostBlockID = try row.get(WanderingGhost.Keys.ghostBlockID)
        posx = try row.get(WanderingGhost.Keys.posx)
        posy = try row.get(WanderingGhost.Keys.posy)
        posz = try row.get(WanderingGhost.Keys.posz)
        replayData = try row.get(WanderingGhost.Keys.replayData)
        port = try row.get(WanderingGhost.Keys.port)
        timestamp = try row.get(WanderingGhost.Keys.timestamp)
    }
    
    // Serializes the WanderingGhost to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(WanderingGhost.Keys.characterID, characterID)
        try row.set(WanderingGhost.Keys.ghostBlockID, ghostBlockID)
        try row.set(WanderingGhost.Keys.posx, posx)
        try row.set(WanderingGhost.Keys.posy, posy)
        try row.set(WanderingGhost.Keys.posz, posz)
        try row.set(WanderingGhost.Keys.replayData, replayData)
        try row.set(WanderingGhost.Keys.port, port)
        try row.set(WanderingGhost.Keys.timestamp, timestamp)
        return row
    }
}

// MARK: Fluent Preparation

extension WanderingGhost: Preparation {
    /// Prepares a table/collection in the database
    /// for storing WanderingGhosts
    static func prepare(_ database: Database) throws {
        try database.modify(self) { builder in
            builder.int(WanderingGhost.Keys.port)
        }
        try database.create(self) { builder in
            builder.id()
            builder.custom(WanderingGhost.Keys.characterID, type: "TEXT")
            builder.int(WanderingGhost.Keys.ghostBlockID)
            builder.double(WanderingGhost.Keys.posx)
            builder.double(WanderingGhost.Keys.posy)
            builder.double(WanderingGhost.Keys.posz)
            builder.custom(WanderingGhost.Keys.replayData, type: "TEXT")
            builder.int(WanderingGhost.Keys.port)
            builder.date(WanderingGhost.Keys.timestamp)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: HTTP

// This allows WanderingGhost models to be returned
// directly in route closures
extension WanderingGhost: ResponseRepresentable { }

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new WanderingGhost (POST /WanderingGhosts)
//     - Fetching a WanderingGhost (GET /WanderingGhosts, GET /WanderingGhosts/:id)
//
extension WanderingGhost: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            characterID: try json.get(WanderingGhost.Keys.characterID),
            ghostBlockID: try json.get(WanderingGhost.Keys.ghostBlockID),
            posx: try json.get(WanderingGhost.Keys.posx),
            posy: try json.get(WanderingGhost.Keys.posy),
            posz: try json.get(WanderingGhost.Keys.posz),
            replayData: try json.get(WanderingGhost.Keys.replayData),
            port: try json.get(WanderingGhost.Keys.port),
            timestamp: try json.get(WanderingGhost.Keys.timestamp)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(WanderingGhost.Keys.id, id)
        try json.set(WanderingGhost.Keys.characterID, characterID)
        try json.set(WanderingGhost.Keys.ghostBlockID, ghostBlockID)
        try json.set(WanderingGhost.Keys.posx, posx)
        try json.set(WanderingGhost.Keys.posy, posy)
        try json.set(WanderingGhost.Keys.posz, posz)
        try json.set(WanderingGhost.Keys.replayData, replayData)
        try json.set(WanderingGhost.Keys.port, port)
        try json.set(WanderingGhost.Keys.timestamp, timestamp)
        return json
    }
}

extension WanderingGhost: DictionaryCreatable {
    convenience init(dictionary: [String: String]) {
        self.init(characterID: dictionary[WanderingGhost.Keys.characterID]!,
                  ghostBlockID: Int32(dictionary[WanderingGhost.Keys.ghostBlockID]!)!,
                  posx: Float32(dictionary[WanderingGhost.Keys.posx]!)!,
                  posy: Float32(dictionary[WanderingGhost.Keys.posy]!)!,
                  posz: Float32(dictionary[WanderingGhost.Keys.posz]!)!,
                  replayData: dictionary[WanderingGhost.Keys.replayData]!)
    }
}
