//
//  Player.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class Player: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Player
    var characterID: String
    var gradeS: UInt32
    var gradeA: UInt32
    var gradeB: UInt32
    var gradeC: UInt32
    var gradeD: UInt32
    var numberOfSessions: UInt32
    var messagesRating: UInt32
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let characterID = "characterID"
        static let gradeS = "gradeS"
        static let gradeA = "gradeA"
        static let gradeB = "gradeB"
        static let gradeC = "gradeC"
        static let gradeD = "gradeD"
        static let numberOfSessions = "numberOfSessions"
        static let messagesRating = "messagesRating"
    }
    
    /// Creates a new Player
    init(characterID: String,
         gradeS: UInt32 = 0,
         gradeA: UInt32 = 0,
         gradeB: UInt32 = 0,
         gradeC: UInt32 = 0,
         gradeD: UInt32 = 0,
         numberOfSessions: UInt32 = 0,
         messagesRating: UInt32 = 0) {
        self.characterID = characterID
        self.gradeS = gradeS
        self.gradeA = gradeA
        self.gradeB = gradeB
        self.gradeC = gradeC
        self.gradeD = gradeD
        self.numberOfSessions = numberOfSessions
        self.messagesRating = messagesRating
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Player from the
    /// database row
    init(row: Row) throws {
        characterID = try row.get(Player.Keys.characterID)
        gradeS = try row.get(Player.Keys.gradeS)
        gradeA = try row.get(Player.Keys.gradeA)
        gradeB = try row.get(Player.Keys.gradeB)
        gradeC = try row.get(Player.Keys.gradeC)
        gradeD = try row.get(Player.Keys.gradeD)
        numberOfSessions = try row.get(Player.Keys.numberOfSessions)
        messagesRating = try row.get(Player.Keys.messagesRating)
    }
    
    // Serializes the Player to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Player.Keys.characterID, characterID)
        try row.set(Player.Keys.gradeS, gradeS)
        try row.set(Player.Keys.gradeA, gradeA)
        try row.set(Player.Keys.gradeB, gradeB)
        try row.set(Player.Keys.gradeC, gradeC)
        try row.set(Player.Keys.gradeD, gradeD)
        try row.set(Player.Keys.numberOfSessions, numberOfSessions)
        try row.set(Player.Keys.messagesRating, messagesRating)
        return row
    }
}

// MARK: Fluent Preparation

extension Player: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Players
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(Player.Keys.characterID, type: "TEXT")
            builder.int(Player.Keys.gradeS)
            builder.int(Player.Keys.gradeA)
            builder.int(Player.Keys.gradeB)
            builder.int(Player.Keys.gradeC)
            builder.int(Player.Keys.gradeD)
            builder.int(Player.Keys.numberOfSessions)
            builder.int(Player.Keys.messagesRating)
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
//     - Creating a new Player (POST /Players)
//     - Fetching a Player (GET /Players, GET /Players/:id)
//
extension Player: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            characterID: try json.get(Player.Keys.characterID),
            gradeS: try json.get(Player.Keys.gradeS),
            gradeA: try json.get(Player.Keys.gradeA),
            gradeB: try json.get(Player.Keys.gradeB),
            gradeC: try json.get(Player.Keys.gradeC),
            gradeD: try json.get(Player.Keys.gradeD),
            numberOfSessions: try json.get(Player.Keys.numberOfSessions),
            messagesRating: try json.get(Player.Keys.messagesRating)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Player.Keys.id, id)
        try json.set(Player.Keys.characterID, characterID)
        try json.set(Player.Keys.gradeS, gradeS)
        try json.set(Player.Keys.gradeA, gradeA)
        try json.set(Player.Keys.gradeB, gradeB)
        try json.set(Player.Keys.gradeC, gradeC)
        try json.set(Player.Keys.gradeD, gradeD)
        try json.set(Player.Keys.numberOfSessions, numberOfSessions)
        try json.set(Player.Keys.messagesRating, messagesRating)
        return json
    }
}

// MARK: Update

// This allows the Player model to be updated
// dynamically by the request.
extension Player: Updateable {
    // Updateable keys are called when `player.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Player>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Player.Keys.numberOfSessions, UInt32.self) { player, numberOfSessions in
                player.numberOfSessions = numberOfSessions
            },
            UpdateableKey(Player.Keys.messagesRating, UInt32.self) { player, messagesRating in
                player.messagesRating = messagesRating
            },
        ]
    }
}

// MARK: Data

extension Player: DataConvertible {
    func makeData() -> Data {
        var data = Data()
        data.append(toData(from: self.gradeS))
        data.append(toData(from: self.gradeA))
        data.append(toData(from: self.gradeB))
        data.append(toData(from: self.gradeC))
        data.append(toData(from: self.gradeD))
        data.append(toData(from: UInt32(0)))
        data.append(toData(from: self.numberOfSessions))
        return data
    }
}
