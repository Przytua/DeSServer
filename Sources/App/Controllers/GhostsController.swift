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
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    let log: LogProtocol
    
    init(redirectController: RedirectController, log: LogProtocol) {
        self.redirectController = redirectController
        self.log = log
    }
    
    func setWanderingGhost(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        var dictionary = toDictionary(from: requestData)
        
        guard let replayData = dictionary["replayData"] else {
            return Response(status: .badRequest)
        }
        
        let fixedReplayData = fix(replayData: replayData)
        guard validate(replayData: fixedReplayData) else {
            return responseBuilder.response(command: 0x17, body: Data(bytes: [0x01]))
        }
        dictionary["replayData"] = fixedReplayData
        
        let wanderingGhost = WanderingGhost(dictionary: dictionary)
        try? wanderingGhost.save()
        
        return responseBuilder.response(command: 0x17, body: Data(bytes: [0x01]))
    }
    
    func getWanderingGhost(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        let oldestTimestamp = Date(timeIntervalSinceNow: -30)
        
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
        
        let ghosts = try WanderingGhost.makeQuery()
            .filter("ghostBlockID", .equals, blockID)
            .filter("characterID", .notEquals, characterID)
            .filter("timestamp", .greaterThanOrEquals, oldestTimestamp)
            .limit(Int(maxGhostNum))
            .all()
        
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
    
    func fix(replayData: String) -> String {
        var fixedReplayData = ""
        for c in replayData {
            if "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/+".contains(c) {
                fixedReplayData += String(c)
            } else if c == " " {
                fixedReplayData += "+"
            } else {
                break
            }
        }
        
        if fixedReplayData.count % 4 == 3 {
            return fixedReplayData + "="
        } else if fixedReplayData.count % 4 == 2 {
            return fixedReplayData + "=="
        } else if fixedReplayData.count % 4 == 1 {
            return fixedReplayData + "A=="
        }
        return fixedReplayData
    }
    
    func validate(replayData: String) -> Bool {
        guard let decoded = Data(base64Encoded: replayData, options: .ignoreUnknownCharacters),
              let uncompressed = try? decoded.gunzipped() else {
            return false
        }
        var posCount: UInt32 = uncompressed[0...3].withUnsafeBytes { $0.pointee }
        posCount = UInt32(bigEndian: posCount)
        let beginning = 12 + (Int(posCount) * 32) + 80
        let end = uncompressed.count
        let playername = String(data: Data(uncompressed[beginning..<end]), encoding: .utf16BigEndian)
        let expectedDataLength = 12 + (Int(posCount) * 32) + (4 * 20) + 34
        return uncompressed.count == expectedDataLength
    }
    
    func cleanupOldGhosts() {
        let oldestTimestamp = Date(timeIntervalSinceNow: -30)
        do {
            try WanderingGhost.makeQuery()
                .filter("timestamp", .lessThan, oldestTimestamp)
                .delete()
        } catch let error {
            log.error(error)
        }
    }
}
