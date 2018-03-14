//
//  SOSData.swift
//  App
//
//  Created by Łukasz Przytuła on 14.03.2018.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class SOSData: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the SOSData
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
    var playerInfo: String
    var qwcwb: UInt32
    var qwclr: UInt32
    var isBlack: UInt8
    var playerLevel: UInt32
    var port: Int
    var timestamp: Date
    var gradeS: UInt32
    var gradeA: UInt32
    var gradeB: UInt32
    var gradeC: UInt32
    var gradeD: UInt32
    var numberOfSessions: UInt32
    
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
        static let playerInfo = "playerInfo"
        static let qwcwb = "qwcwb"
        static let qwclr = "qwclr"
        static let isBlack = "isBlack"
        static let playerLevel = "playerLevel"
        static let port = "port"
        static let timestamp = "timestamp"
        static let gradeS = "gradeS"
        static let gradeA = "gradeA"
        static let gradeB = "gradeB"
        static let gradeC = "gradeC"
        static let gradeD = "gradeD"
        static let numberOfSessions = "numberOfSessions"
    }
    
    /// Creates a new SOSData
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
         playerInfo: String,
         qwcwb: UInt32,
         qwclr: UInt32,
         isBlack: UInt8,
         playerLevel: UInt32,
         port: Int = 0,
         timestamp: Date = Date(),
         gradeS: UInt32 = 0,
         gradeA: UInt32 = 0,
         gradeB: UInt32 = 0,
         gradeC: UInt32 = 0,
         gradeD: UInt32 = 0,
         numberOfSessions: UInt32 = 0) {
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
        self.playerInfo = playerInfo
        self.qwcwb = qwcwb
        self.qwclr = qwclr
        self.isBlack = isBlack
        self.playerLevel = playerLevel
        self.port = port
        self.timestamp = timestamp
        self.gradeS = gradeS
        self.gradeA = gradeA
        self.gradeB = gradeB
        self.gradeC = gradeC
        self.gradeD = gradeD
        self.numberOfSessions = numberOfSessions
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the SOSData from the
    /// database row
    init(row: Row) throws {
        characterID = try row.get(SOSData.Keys.characterID)
        blockID = try row.get(SOSData.Keys.blockID)
        posx = try row.get(SOSData.Keys.posx)
        posy = try row.get(SOSData.Keys.posy)
        posz = try row.get(SOSData.Keys.posz)
        angx = try row.get(SOSData.Keys.angx)
        angy = try row.get(SOSData.Keys.angy)
        angz = try row.get(SOSData.Keys.angz)
        messageID = try row.get(SOSData.Keys.messageID)
        mainMsgID = try row.get(SOSData.Keys.mainMsgID)
        addMsgCateID = try row.get(SOSData.Keys.addMsgCateID)
        playerInfo = try row.get(SOSData.Keys.playerInfo)
        qwcwb = try row.get(SOSData.Keys.qwcwb)
        qwclr = try row.get(SOSData.Keys.qwclr)
        isBlack = try row.get(SOSData.Keys.isBlack)
        playerLevel = try row.get(SOSData.Keys.playerLevel)
        port = try row.get(SOSData.Keys.port)
        timestamp = try row.get(SOSData.Keys.timestamp)
        gradeS = try row.get(SOSData.Keys.gradeS)
        gradeA = try row.get(SOSData.Keys.gradeA)
        gradeB = try row.get(SOSData.Keys.gradeB)
        gradeC = try row.get(SOSData.Keys.gradeC)
        gradeD = try row.get(SOSData.Keys.gradeD)
        numberOfSessions = try row.get(SOSData.Keys.numberOfSessions)
    }
    
    // Serializes the SOSData to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(SOSData.Keys.characterID, characterID)
        try row.set(SOSData.Keys.blockID, blockID)
        try row.set(SOSData.Keys.posx, posx)
        try row.set(SOSData.Keys.posy, posy)
        try row.set(SOSData.Keys.posz, posz)
        try row.set(SOSData.Keys.angx, angx)
        try row.set(SOSData.Keys.angy, angy)
        try row.set(SOSData.Keys.angz, angz)
        try row.set(SOSData.Keys.messageID, messageID)
        try row.set(SOSData.Keys.mainMsgID, mainMsgID)
        try row.set(SOSData.Keys.addMsgCateID, addMsgCateID)
        try row.set(SOSData.Keys.playerInfo, playerInfo)
        try row.set(SOSData.Keys.qwcwb, qwcwb)
        try row.set(SOSData.Keys.qwclr, qwclr)
        try row.set(SOSData.Keys.isBlack, isBlack)
        try row.set(SOSData.Keys.playerLevel, playerLevel)
        try row.set(SOSData.Keys.port, port)
        try row.set(SOSData.Keys.timestamp, timestamp)
        try row.set(SOSData.Keys.gradeS, gradeS)
        try row.set(SOSData.Keys.gradeA, gradeA)
        try row.set(SOSData.Keys.gradeB, gradeB)
        try row.set(SOSData.Keys.gradeC, gradeC)
        try row.set(SOSData.Keys.gradeD, gradeD)
        try row.set(SOSData.Keys.numberOfSessions, numberOfSessions)
        return row
    }
}

// MARK: Fluent Preparation

extension SOSData: Preparation {
    /// Prepares a table/collection in the database
    /// for storing SOSDatas
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(SOSData.Keys.characterID, type: "TEXT")
            builder.int(SOSData.Keys.blockID)
            builder.double(SOSData.Keys.posx)
            builder.double(SOSData.Keys.posy)
            builder.double(SOSData.Keys.posz)
            builder.double(SOSData.Keys.angx)
            builder.double(SOSData.Keys.angy)
            builder.double(SOSData.Keys.angz)
            builder.int(SOSData.Keys.messageID)
            builder.int(SOSData.Keys.mainMsgID)
            builder.int(SOSData.Keys.addMsgCateID)
            builder.custom(SOSData.Keys.playerInfo, type: "TEXT")
            builder.int(SOSData.Keys.qwcwb)
            builder.int(SOSData.Keys.qwclr)
            builder.int(SOSData.Keys.isBlack)
            builder.int(SOSData.Keys.playerLevel)
            builder.int(SOSData.Keys.port)
            builder.date(SOSData.Keys.timestamp)
            builder.int(SOSData.Keys.gradeS)
            builder.int(SOSData.Keys.gradeA)
            builder.int(SOSData.Keys.gradeB)
            builder.int(SOSData.Keys.gradeC)
            builder.int(SOSData.Keys.gradeD)
            builder.int(SOSData.Keys.numberOfSessions)
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
//     - Creating a new SOSData (POST /SOSDatas)
//     - Fetching a SOSData (GET /SOSDatas, GET /SOSDatas/:id)
//
extension SOSData: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            characterID: try json.get(SOSData.Keys.characterID),
            blockID: try json.get(SOSData.Keys.blockID),
            posx: try json.get(SOSData.Keys.posx),
            posy: try json.get(SOSData.Keys.posy),
            posz: try json.get(SOSData.Keys.posz),
            angx: try json.get(SOSData.Keys.angx),
            angy: try json.get(SOSData.Keys.angy),
            angz: try json.get(SOSData.Keys.angz),
            messageID: try json.get(SOSData.Keys.messageID),
            mainMsgID: try json.get(SOSData.Keys.mainMsgID),
            addMsgCateID: try json.get(SOSData.Keys.addMsgCateID),
            playerInfo: try json.get(SOSData.Keys.playerInfo),
            qwcwb: try json.get(SOSData.Keys.qwcwb),
            qwclr: try json.get(SOSData.Keys.qwclr),
            isBlack: try json.get(SOSData.Keys.isBlack),
            playerLevel: try json.get(SOSData.Keys.playerLevel),
            port: try json.get(SOSData.Keys.port),
            timestamp: try json.get(SOSData.Keys.timestamp),
            gradeS: try json.get(SOSData.Keys.gradeS),
            gradeA: try json.get(SOSData.Keys.gradeA),
            gradeB: try json.get(SOSData.Keys.gradeB),
            gradeC: try json.get(SOSData.Keys.gradeC),
            gradeD: try json.get(SOSData.Keys.gradeD),
            numberOfSessions: try json.get(SOSData.Keys.numberOfSessions)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(SOSData.Keys.id, id)
        try json.set(SOSData.Keys.characterID, characterID)
        try json.set(SOSData.Keys.blockID, blockID)
        try json.set(SOSData.Keys.posx, posx)
        try json.set(SOSData.Keys.posy, posy)
        try json.set(SOSData.Keys.posz, posz)
        try json.set(SOSData.Keys.angx, angx)
        try json.set(SOSData.Keys.angy, angy)
        try json.set(SOSData.Keys.angz, angz)
        try json.set(SOSData.Keys.messageID, messageID)
        try json.set(SOSData.Keys.mainMsgID, mainMsgID)
        try json.set(SOSData.Keys.addMsgCateID, addMsgCateID)
        try json.set(SOSData.Keys.playerInfo, playerInfo)
        try json.set(SOSData.Keys.qwcwb, qwcwb)
        try json.set(SOSData.Keys.qwclr, qwclr)
        try json.set(SOSData.Keys.isBlack, isBlack)
        try json.set(SOSData.Keys.playerLevel, playerLevel)
        try json.set(SOSData.Keys.timestamp, timestamp)
        try json.set(SOSData.Keys.gradeS, gradeS)
        try json.set(SOSData.Keys.gradeA, gradeA)
        try json.set(SOSData.Keys.gradeB, gradeB)
        try json.set(SOSData.Keys.gradeC, gradeC)
        try json.set(SOSData.Keys.gradeD, gradeD)
        try json.set(SOSData.Keys.numberOfSessions, numberOfSessions)
        return json
    }
}

// MARK: HTTP

// This allows SOSData models to be returned
// directly in route closures
extension SOSData: ResponseRepresentable { }

extension SOSData: DataConvertible {
    func makeData() -> Data {
        var data = Data()
        let id = self.id != nil ? Int32(self.id!.int!) : Int32(0)
        data.append(toData(from: id))
        data.append(self.characterID.data(using: .utf8)!)
        data.append([0x00], count: 1)
        data.append(toData(from: self.posx))
        data.append(toData(from: self.posy))
        data.append(toData(from: self.posz))
        data.append(toData(from: self.angx))
        data.append(toData(from: self.angy))
        data.append(toData(from: self.angz))
        data.append(toData(from: self.messageID))
        data.append(toData(from: self.mainMsgID))
        data.append(toData(from: self.addMsgCateID))
        data.append(toData(from: UInt32(0)))
        data.append(toData(from: self.gradeS))
        data.append(toData(from: self.gradeA))
        data.append(toData(from: self.gradeB))
        data.append(toData(from: self.gradeC))
        data.append(toData(from: self.gradeD))
        data.append(toData(from: UInt32(0)))
        data.append(toData(from: self.numberOfSessions))
        data.append(self.playerInfo.data(using: .utf8)!)
        data.append([0x00], count: 1)
        data.append(toData(from: self.qwcwb))
        data.append(toData(from: self.qwclr))
        data.append(toData(from: self.isBlack))
        return data
    }
}

extension SOSData: DictionaryCreatable {
    convenience init(dictionary: [String: String]) {
        self.init(characterID: dictionary[SOSData.Keys.characterID]!,
                  blockID: Int32(dictionary[SOSData.Keys.blockID]!)!,
                  posx: Float32(dictionary[SOSData.Keys.posx]!)!,
                  posy: Float32(dictionary[SOSData.Keys.posy]!)!,
                  posz: Float32(dictionary[SOSData.Keys.posz]!)!,
                  angx: Float32(dictionary[SOSData.Keys.angx]!)!,
                  angy: Float32(dictionary[SOSData.Keys.angy]!)!,
                  angz: Float32(dictionary[SOSData.Keys.angz]!)!,
                  messageID: UInt32(dictionary[SOSData.Keys.messageID]!)!,
                  mainMsgID: UInt32(dictionary[SOSData.Keys.mainMsgID]!)!,
                  addMsgCateID: UInt32(dictionary[SOSData.Keys.addMsgCateID]!)!,
                  playerInfo: dictionary[SOSData.Keys.playerInfo]!,
                  qwcwb: UInt32(dictionary[SOSData.Keys.qwcwb]!)!,
                  qwclr: UInt32(dictionary[SOSData.Keys.qwclr]!)!,
                  isBlack: UInt8(dictionary[SOSData.Keys.isBlack]!)!,
                  playerLevel: UInt32(dictionary[SOSData.Keys.playerLevel]!)!)
    }
}


