//
//  GhostsController.swift
//  App
//
//  Created by Łukasz Przytuła on 05.03.2018.
//

import Vapor
import Foundation
import Gzip

class GhostsController {
    
    let decryptor = Decryptor()
    let responseBuilder = ResponseBuilder()
    let log: LogProtocol
    let base64Mender = Base64Mender()
    let replayDataValidator = ReplayDataValidator()
    
    let oldGhostsTimeInterval: TimeInterval = -TimeInterval(wanderingGhostInterval)
    
    init(log: LogProtocol) {
        self.log = log
    }
    
    func setWanderingGhost(_ request: Request) throws -> Response {
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        var dictionary = toDictionary(from: requestData)
        
        guard let replayData = dictionary["replayData"] else {
            return Response(status: .badRequest)
        }
        
        let fixedReplayData = base64Mender.fix(replayData: replayData)
        guard replayDataValidator.validate(replayData: fixedReplayData) else {
            return responseBuilder.response(command: 0x17, body: Data(bytes: [0x01]))
        }
        dictionary["replayData"] = fixedReplayData
        
        let wanderingGhost = WanderingGhost(dictionary: dictionary)
        try? wanderingGhost.save()
        
        return responseBuilder.response(command: 0x17, body: Data(bytes: [0x01]))
    }
    
    func getWanderingGhost(_ request: Request) throws -> Response {
        let oldestTimestamp = Date(timeIntervalSinceNow: oldGhostsTimeInterval)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let characterID = dictionary["characterID"],
              let blockIDString = dictionary["blockID"],
              let blockID = Int32(blockIDString),
              let maxGhostNumString = dictionary["maxGhostNum"],
              let maxGhostNum = Int32(maxGhostNumString) else {
            return Response(status: .badRequest)
        }
        
        background {
            self.cleanupOldGhosts()
        }
        
        guard let ghosts = try? WanderingGhost.makeQuery()
              .filter("ghostBlockID", .equals, blockID)
              .filter("characterID", .notEquals, characterID)
              .filter("timestamp", .greaterThanOrEquals, oldestTimestamp)
              .limit(Int(maxGhostNum))
              .all() else {
            return responseBuilder.response(command: 0x11, body: toData(from: UInt32(0)))
        }
        
        var responseData = Data()
        responseData.append(toData(from: UInt32(0)))
        responseData.append(toData(from: UInt32(ghosts.count)))
        for ghost in ghosts {
            let ghostReplay = ghost.replayData.replacingOccurrences(of: "+", with: " ")
            responseData.append(toData(from: UInt32(ghostReplay.count)))
            responseData.append(ghostReplay.data(using: .utf8)!)
        }
        
        return responseBuilder.response(command: 0x11, body: responseData)
    }
    
    func cleanupOldGhosts() {
        let oldestTimestamp = Date(timeIntervalSinceNow: oldGhostsTimeInterval)
        do {
            try WanderingGhost.makeQuery()
                .filter("timestamp", .lessThan, oldestTimestamp)
                .delete()
        } catch let error {
            log.error(error)
        }
    }
}
