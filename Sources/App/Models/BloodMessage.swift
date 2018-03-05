//
//  BloodMessage.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class BloodMessage: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the BloodMessage
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
    var rating: UInt32
    
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
        static let rating = "rating"
    }
    
    /// Creates a new BloodMessage
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
         rating: UInt32) {
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
        self.rating = rating
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the BloodMessage from the
    /// database row
    init(row: Row) throws {
        characterID = try row.get(BloodMessage.Keys.characterID)
        blockID = try row.get(BloodMessage.Keys.blockID)
        posx = try row.get(BloodMessage.Keys.posx)
        posy = try row.get(BloodMessage.Keys.posy)
        posz = try row.get(BloodMessage.Keys.posz)
        angx = try row.get(BloodMessage.Keys.angx)
        angy = try row.get(BloodMessage.Keys.angy)
        angz = try row.get(BloodMessage.Keys.angz)
        messageID = try row.get(BloodMessage.Keys.messageID)
        mainMsgID = try row.get(BloodMessage.Keys.mainMsgID)
        addMsgCateID = try row.get(BloodMessage.Keys.addMsgCateID)
        rating = try row.get(BloodMessage.Keys.rating)
    }
    
    // Serializes the BloodMessage to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(BloodMessage.Keys.characterID, characterID)
        try row.set(BloodMessage.Keys.blockID, blockID)
        try row.set(BloodMessage.Keys.posx, posx)
        try row.set(BloodMessage.Keys.posy, posy)
        try row.set(BloodMessage.Keys.posz, posz)
        try row.set(BloodMessage.Keys.angx, angx)
        try row.set(BloodMessage.Keys.angy, angy)
        try row.set(BloodMessage.Keys.angz, angz)
        try row.set(BloodMessage.Keys.messageID, messageID)
        try row.set(BloodMessage.Keys.mainMsgID, mainMsgID)
        try row.set(BloodMessage.Keys.addMsgCateID, addMsgCateID)
        try row.set(BloodMessage.Keys.rating, rating)
        return row
    }
}

// MARK: Fluent Preparation

extension BloodMessage: Preparation {
    /// Prepares a table/collection in the database
    /// for storing BloodMessages
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(BloodMessage.Keys.characterID, type: "TEXT")
            builder.int(BloodMessage.Keys.blockID)
            builder.double(BloodMessage.Keys.posx)
            builder.double(BloodMessage.Keys.posy)
            builder.double(BloodMessage.Keys.posz)
            builder.double(BloodMessage.Keys.angx)
            builder.double(BloodMessage.Keys.angy)
            builder.double(BloodMessage.Keys.angz)
            builder.int(BloodMessage.Keys.messageID)
            builder.int(BloodMessage.Keys.mainMsgID)
            builder.int(BloodMessage.Keys.addMsgCateID)
            builder.int(BloodMessage.Keys.rating)
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
//     - Creating a new BloodMessage (POST /BloodMessages)
//     - Fetching a BloodMessage (GET /BloodMessages, GET /BloodMessages/:id)
//
extension BloodMessage: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            characterID: try json.get(BloodMessage.Keys.characterID),
            blockID: try json.get(BloodMessage.Keys.blockID),
            posx: try json.get(BloodMessage.Keys.posx),
            posy: try json.get(BloodMessage.Keys.posy),
            posz: try json.get(BloodMessage.Keys.posz),
            angx: try json.get(BloodMessage.Keys.angx),
            angy: try json.get(BloodMessage.Keys.angy),
            angz: try json.get(BloodMessage.Keys.angz),
            messageID: try json.get(BloodMessage.Keys.messageID),
            mainMsgID: try json.get(BloodMessage.Keys.mainMsgID),
            addMsgCateID: try json.get(BloodMessage.Keys.addMsgCateID),
            rating: try json.get(BloodMessage.Keys.rating)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(BloodMessage.Keys.id, id)
        try json.set(BloodMessage.Keys.characterID, characterID)
        try json.set(BloodMessage.Keys.blockID, blockID)
        try json.set(BloodMessage.Keys.posx, posx)
        try json.set(BloodMessage.Keys.posy, posy)
        try json.set(BloodMessage.Keys.posz, posz)
        try json.set(BloodMessage.Keys.angx, angx)
        try json.set(BloodMessage.Keys.angy, angy)
        try json.set(BloodMessage.Keys.angz, angz)
        try json.set(BloodMessage.Keys.messageID, messageID)
        try json.set(BloodMessage.Keys.mainMsgID, mainMsgID)
        try json.set(BloodMessage.Keys.addMsgCateID, addMsgCateID)
        try json.set(BloodMessage.Keys.rating, rating)
        return json
    }
}

// MARK: HTTP

// This allows BloodMessage models to be returned
// directly in route closures
extension BloodMessage: ResponseRepresentable { }

// MARK: Update

// This allows the BloodMessage model to be updated
// dynamically by the request.
extension BloodMessage: Updateable {
    // Updateable keys are called when `bloodMessage.update(for: req)` is called.
    public static var updateableKeys: [UpdateableKey<BloodMessage>] {
        return [
            UpdateableKey(BloodMessage.Keys.rating, UInt32.self) { bloodMessage, rating in
                bloodMessage.rating = rating
            }
        ]
    }
}

extension BloodMessage: DataConvertible {
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
        data.append(toData(from: self.rating))
        return data
    }
}

extension BloodMessage: DictionaryCreatable {
    convenience init(dictionary: [String: String]) {
        self.init(characterID: dictionary[BloodMessage.Keys.characterID]!,
                  blockID: Int32(dictionary[BloodMessage.Keys.blockID]!)!,
                  posx: Float32(dictionary[BloodMessage.Keys.posx]!)!,
                  posy: Float32(dictionary[BloodMessage.Keys.posy]!)!,
                  posz: Float32(dictionary[BloodMessage.Keys.posz]!)!,
                  angx: Float32(dictionary[BloodMessage.Keys.angx]!)!,
                  angy: Float32(dictionary[BloodMessage.Keys.angy]!)!,
                  angz: Float32(dictionary[BloodMessage.Keys.angz]!)!,
                  messageID: UInt32(dictionary[BloodMessage.Keys.messageID]!)!,
                  mainMsgID: UInt32(dictionary[BloodMessage.Keys.mainMsgID]!)!,
                  addMsgCateID: UInt32(dictionary[BloodMessage.Keys.addMsgCateID]!)!,
                  rating: UInt32(0))
    }
}

