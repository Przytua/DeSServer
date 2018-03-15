//
//  ReplayController.swift
//  App
//
//  Created by Łukasz Przytuła on 13.03.2018.
//

import Foundation

class ReplayController {
    
    let decryptor = Decryptor()
    let responseBuilder = ResponseBuilder()
    let log: LogProtocol
    let base64Mender = Base64Mender()
    let replayBinaryValidator = ReplayDataValidator()
    
    init(log: LogProtocol) {
        self.log = log
    }
    
    func addReplayData(_ request: Request) throws -> Response {
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        var dictionary = toDictionary(from: requestData)
        
        guard let replayBinary = dictionary["replayBinary"] else {
            return Response(status: .badRequest)
        }
        
        let fixedReplayData = base64Mender.fix(replayData: replayBinary)
        guard replayBinaryValidator.validate(replayData: fixedReplayData) else {
            return responseBuilder.response(command: 0x1d, body: Data(bytes: [0x01]))
        }
        dictionary["replayBinary"] = fixedReplayData
        
        let replay = Replay(dictionary: dictionary)
        try? replay.save()
        
        return responseBuilder.response(command: 0x1d, body: Data(bytes: [0x01]))
    }
    
    func getReplayList(_ request: Request) throws -> Response {
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let blockIDString = dictionary["blockID"],
              let blockID = Int32(blockIDString),
              let replayNumString = dictionary["replayNum"],
              let limit = Int(replayNumString) else {
            return Response(status: .badRequest)
        }
        
        guard let replays = try? Replay.makeQuery()
              .filter("blockID", .equals, blockID)
              .sort("id", .descending)
              .limit(limit)
              .all() else {
            return responseBuilder.response(command: 0x1f, body: toData(from: UInt32(0)))
        }
        
        var serializedReplays = Data()
        serializedReplays.append(toData(from: UInt32(replays.count)))
        for replay in replays {
            serializedReplays.append(replay.makeData())
        }
        
        return responseBuilder.response(command: 0x1f, body: serializedReplays)
    }
    
    func getReplayData(_ request: Request) throws -> Response {
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let ghostIDString = dictionary["ghostID"],
              let ghostID = Int32(ghostIDString) else {
            return Response(status: .badRequest)
        }
        
        guard let replay = try Replay.find(ghostID) else {
            return Response(status: .badRequest)
        }
        
        var responseData = Data()
        responseData.append(toData(from: ghostID))
        let ghostReplay = replay.replayBinary.replacingOccurrences(of: "+", with: " ")
        responseData.append(toData(from: UInt32(ghostReplay.count)))
        responseData.append(ghostReplay.data(using: .utf8)!)
        
        return responseBuilder.response(command: 0x1e, body: responseData)
    }
}
