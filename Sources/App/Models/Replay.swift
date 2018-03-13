//
//  Replay.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class Replay: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the Replay
    var characterID: String
    var blockID: Int32
    var posx: Float32
    var posy: Float32
    var posz: Float32
    var angx: Float32
    var angy: Float32
    var angz: Float32
    var messageID: UInt32
    var mainMsgID: UInt32
    var addMsgCateID: UInt32
    var replayBinary: String
    var timestamp: Date
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let characterID = "characterID"
        static let blockID = "blockID"
        static let posx = "posx"
        static let posy = "posy"
        static let posz = "posz"
        static let angx = "angx"
        static let angy = "angy"
        static let angz = "angz"
        static let messageID = "messageID"
        static let mainMsgID = "mainMsgID"
        static let addMsgCateID = "addMsgCateID"
        static let replayBinary = "replayBinary"
        static let timestamp = "timestamp"
    }
    
    /// Creates a new Replay
    init(characterID: String,
         blockID: Int32,
         posx: Float32,
         posy: Float32,
         posz: Float32,
         angx: Float32,
         angy: Float32,
         angz: Float32,
         messageID: UInt32,
         mainMsgID: UInt32,
         addMsgCateID: UInt32,
         replayBinary: String,
         timestamp: Date = Date()) {
        self.characterID = characterID
        self.blockID = blockID
        self.posx = posx
        self.posy = posy
        self.posz = posz
        self.angx = angx
        self.angy = angy
        self.angz = angz
        self.messageID = messageID
        self.mainMsgID = mainMsgID
        self.addMsgCateID = addMsgCateID
        self.replayBinary = replayBinary
        self.timestamp = timestamp
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Replay from the
    /// database row
    init(row: Row) throws {
        characterID = try row.get(Replay.Keys.characterID)
        blockID = try row.get(Replay.Keys.blockID)
        posx = try row.get(Replay.Keys.posx)
        posy = try row.get(Replay.Keys.posy)
        posz = try row.get(Replay.Keys.posz)
        angx = try row.get(Replay.Keys.angx)
        angy = try row.get(Replay.Keys.angy)
        angz = try row.get(Replay.Keys.angz)
        messageID = try row.get(Replay.Keys.messageID)
        mainMsgID = try row.get(Replay.Keys.mainMsgID)
        addMsgCateID = try row.get(Replay.Keys.addMsgCateID)
        replayBinary = try row.get(Replay.Keys.replayBinary)
        timestamp = try row.get(Replay.Keys.timestamp)
    }
    
    // Serializes the Replay to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Replay.Keys.characterID, characterID)
        try row.set(Replay.Keys.blockID, blockID)
        try row.set(Replay.Keys.posx, posx)
        try row.set(Replay.Keys.posy, posy)
        try row.set(Replay.Keys.posz, posz)
        try row.set(Replay.Keys.angx, angx)
        try row.set(Replay.Keys.angy, angy)
        try row.set(Replay.Keys.angz, angz)
        try row.set(Replay.Keys.messageID, messageID)
        try row.set(Replay.Keys.mainMsgID, mainMsgID)
        try row.set(Replay.Keys.addMsgCateID, addMsgCateID)
        try row.set(Replay.Keys.replayBinary, replayBinary)
        try row.set(Replay.Keys.timestamp, timestamp)
        return row
    }
}

// MARK: Fluent Preparation

extension Replay: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Replays
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(Replay.Keys.characterID, type: "TEXT")
            builder.int(Replay.Keys.blockID)
            builder.double(Replay.Keys.posx)
            builder.double(Replay.Keys.posy)
            builder.double(Replay.Keys.posz)
            builder.double(Replay.Keys.angx)
            builder.double(Replay.Keys.angy)
            builder.double(Replay.Keys.angz)
            builder.int(Replay.Keys.messageID)
            builder.int(Replay.Keys.mainMsgID)
            builder.int(Replay.Keys.addMsgCateID)
            builder.custom(Replay.Keys.replayBinary, type: "TEXT")
            builder.date(Replay.Keys.timestamp)
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
//     - Creating a new Replay (POST /Replays)
//     - Fetching a Replay (GET /Replays, GET /Replays/:id)
//
extension Replay: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            characterID: try json.get(Replay.Keys.characterID),
            blockID: try json.get(Replay.Keys.blockID),
            posx: try json.get(Replay.Keys.posx),
            posy: try json.get(Replay.Keys.posy),
            posz: try json.get(Replay.Keys.posz),
            angx: try json.get(Replay.Keys.angx),
            angy: try json.get(Replay.Keys.angy),
            angz: try json.get(Replay.Keys.angz),
            messageID: try json.get(Replay.Keys.messageID),
            mainMsgID: try json.get(Replay.Keys.mainMsgID),
            addMsgCateID: try json.get(Replay.Keys.addMsgCateID),
            replayBinary: try json.get(Replay.Keys.replayBinary),
            timestamp: try json.get(Replay.Keys.timestamp)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Replay.Keys.id, id)
        try json.set(Replay.Keys.characterID, characterID)
        try json.set(Replay.Keys.blockID, blockID)
        try json.set(Replay.Keys.posx, posx)
        try json.set(Replay.Keys.posy, posy)
        try json.set(Replay.Keys.posz, posz)
        try json.set(Replay.Keys.angx, angx)
        try json.set(Replay.Keys.angy, angy)
        try json.set(Replay.Keys.angz, angz)
        try json.set(Replay.Keys.messageID, messageID)
        try json.set(Replay.Keys.mainMsgID, mainMsgID)
        try json.set(Replay.Keys.addMsgCateID, addMsgCateID)
        try json.set(Replay.Keys.replayBinary, replayBinary)
        try json.set(Replay.Keys.timestamp, timestamp)
        return json
    }
}

// MARK: HTTP

// This allows Replay models to be returned
// directly in route closures
extension Replay: ResponseRepresentable { }

extension Replay: DataConvertible {
    func makeData() -> Data {
        var data = Data()
        let id = self.id != nil ? Int32(self.id!.int!) : Int32(0)
        data.append(toData(from: id))
        data.append(self.characterID.data(using: .utf8)!)
        data.append([0x00], count: 1)
        data.append(toData(from: self.blockID))
        data.append(toData(from: self.posx))
        data.append(toData(from: self.posy))
        data.append(toData(from: self.posz))
        data.append(toData(from: self.angx))
        data.append(toData(from: self.angy))
        data.append(toData(from: self.angz))
        data.append(toData(from: self.messageID))
        data.append(toData(from: self.mainMsgID))
        data.append(toData(from: self.addMsgCateID))
        return data
    }
}

extension Replay: DictionaryCreatable {
    convenience init(dictionary: [String: String]) {
        self.init(characterID: dictionary[Replay.Keys.characterID]!,
                  blockID: Int32(dictionary[Replay.Keys.blockID]!)!,
                  posx: Float32(dictionary[Replay.Keys.posx]!)!,
                  posy: Float32(dictionary[Replay.Keys.posy]!)!,
                  posz: Float32(dictionary[Replay.Keys.posz]!)!,
                  angx: Float32(dictionary[Replay.Keys.angx]!)!,
                  angy: Float32(dictionary[Replay.Keys.angy]!)!,
                  angz: Float32(dictionary[Replay.Keys.angz]!)!,
                  messageID: UInt32(dictionary[Replay.Keys.messageID]!)!,
                  mainMsgID: UInt32(dictionary[Replay.Keys.mainMsgID]!)!,
                  addMsgCateID: UInt32(dictionary[Replay.Keys.addMsgCateID]!)!,
                  replayBinary: dictionary[Replay.Keys.replayBinary]!)
    }
}


