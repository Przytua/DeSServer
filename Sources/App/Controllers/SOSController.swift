//
//  SOSController.swift
//  App
//
//  Created by Łukasz Przytuła on 14.03.2018.
//

import Foundation

class SOSController {
    
    let decryptor = Decryptor()
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    let log: LogProtocol
    let serverSettings = ServerSettings()
    
    var openRooms: [String: String] = [:]
    
    init(redirectController: RedirectController, log: LogProtocol) {
        self.redirectController = redirectController
        self.log = log
    }
    
    func addSosData(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        let port = Int(request.uri.port!)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        let sos = SOSData(dictionary: dictionary)
        sos.port = port
        if let player = try Player.makeQuery().filter("characterID", .equals, sos.characterID).first() {
            sos.gradeS = player.gradeS
            sos.gradeA = player.gradeA
            sos.gradeB = player.gradeB
            sos.gradeC = player.gradeC
            sos.gradeD = player.gradeD
            sos.numberOfSessions = player.numberOfSessions
        }
        try sos.save()
        
        return responseBuilder.response(command: 0x0a, body: Data(bytes: [0x01]))
    }
    
    func getSosData(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        let oldestTimestamp = Date(timeIntervalSinceNow: -30)
        let port = Int(request.uri.port!)
        
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let blockIDString = dictionary["blockID"],
              let blockID = Int32(blockIDString),
              let maxSosNumString = dictionary["maxSosNum"],
              let limit = Int(maxSosNumString),
              let sosList = dictionary["sosNum"]?.components(separatedBy: "a0a") else {
            return Response(status: .badRequest)
        }
        
        var knownSOS: [UInt32] = []
        var newSOS: [SOSData] = []
        
        var query = try SOSData.makeQuery()
            .filter("blockID", .equals, blockID)
            .filter("timestamp", .greaterThanOrEquals, oldestTimestamp)
        if (!serverSettings.crossRegionMatchmaking) {
            query = try query.filter("port", .equals, port)
        }
        guard let activeSOS = try? query.limit(limit).all() else {
            return responseBuilder.response(command: 0x11, body: toData(from: UInt32(0)))
        }
        
        for sosData in activeSOS {
            if sosList.contains(sosData.id!.string!) {
                knownSOS.append(UInt32(sosData.id!.int!))
            } else {
                newSOS.append(sosData)
            }
        }
        
        var responseData = Data()
        responseData.append(toData(from: UInt32(knownSOS.count)))
        for sosID in knownSOS {
            responseData.append(toData(from: sosID))
        }
        responseData.append(toData(from: UInt32(newSOS.count)))
        for sosData in newSOS {
            responseData.append(sosData.makeData())
        }
        
        return responseBuilder.response(command: 0x0f, body: responseData)
    }
    
    func cleanupOldSOS() {
        let oldestTimestamp = Date(timeIntervalSinceNow: -30)
        do {
            try SOSData.makeQuery()
                .filter("timestamp", .lessThan, oldestTimestamp)
                .delete()
        } catch let error {
            log.error(error)
        }
    }
    
    func checkSosData(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        let port = Int(request.uri.port!)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let characterID = dictionary["characterID"] else {
            return Response(status: .badRequest)
        }
        
        if let sos = try SOSData.makeQuery()
                         .filter("characterID", .equals, characterID)
                         .first() {
            sos.timestamp = Date()
            sos.port = port
            try sos.save()
        }
        
        guard let roomID = openRooms[characterID],
              let roomIDData = roomID.data(using: .utf8) else {
            return responseBuilder.response(command: 0x0b, body: Data(bytes: [0x01]))
        }
        return responseBuilder.response(command: 0x0b, body: roomIDData)
    }
    
    func summonOtherCharacter(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let ghostIDString = dictionary["ghostID"],
              let ghostID = Int(ghostIDString),
              let roomID = dictionary["NPRoomID"] else {
            return Response(status: .badRequest)
        }
        
        guard let sos = try SOSData.find(ghostID) else {
            return responseBuilder.response(command: 0x0a, body: Data(bytes: [0x00]))
        }
        openRooms[sos.characterID] = roomID
        
        return responseBuilder.response(command: 0x0a, body: Data(bytes: [0x01]))
    }
    
    func summonBlackGhost(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        let oldestTimestamp = Date(timeIntervalSinceNow: -30)
        let port = Int(request.uri.port!)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let roomID = dictionary["NPRoomID"] else {
            return Response(status: .badRequest)
        }
        
        var query = try SOSData.makeQuery()
            .filter("blockID", .greaterThanOrEquals, 40000)
            .filter("blockID", .lessThan, 50000)
            .filter("timestamp", .greaterThanOrEquals, oldestTimestamp)
        if (!serverSettings.crossRegionMatchmaking) {
            query = try query.filter("port", .equals, port)
        }
        guard let sos = try query.first() else {
            return responseBuilder.response(command: 0x23, body: Data(bytes: [0x00]))
        }
        openRooms[sos.characterID] = roomID
        
        return responseBuilder.response(command: 0x23, body: Data(bytes: [0x01]))
    }
    
    func outOfBlock(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let characterID = dictionary["characterID"] else {
            return Response(status: .badRequest)
        }
        
        if let sos = try SOSData.makeQuery().filter("characterID", .equals, characterID).first() {
            try sos.delete()
        }
        
        return responseBuilder.response(command: 0x15, body: Data(bytes: [0x01]))
    }
}
