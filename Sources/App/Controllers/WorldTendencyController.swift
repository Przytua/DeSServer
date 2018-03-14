//
//  ReplayController.swift
//  App
//
//  Created by Łukasz Przytuła on 13.03.2018.
//

import Foundation

class WorldTendencyController {
    
    let decryptor = Decryptor()
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    
    let pwwtData = Data(bytes: [0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    let pbwtData = Data(bytes: [0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    
    init(redirectController: RedirectController) {
        self.redirectController = redirectController
    }
    
    func addQWCData(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        let worldTendency = WorldTendency(dictionary: dictionary)
        try? worldTendency.save()
        
        return responseBuilder.response(command: 0x09, body: Data(bytes: [0x01]))
    }
    
    func getQWCData(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let maxNumString = dictionary["maxNum"],
              let limit = Int(maxNumString) else {
            return Response(status: .badRequest)
        }
        
        let limitedQuery = try WorldTendency.makeQuery()
            .sort("id", .descending)
            .limit(limit)
        
        guard let avg1 = try limitedQuery.aggregate("wb1", .average).double,
              let avg2 = try limitedQuery.aggregate("wb2", .average).double,
              let avg3 = try limitedQuery.aggregate("wb3", .average).double,
              let avg4 = try limitedQuery.aggregate("wb4", .average).double,
              let avg5 = try limitedQuery.aggregate("wb5", .average).double,
              let avg6 = try limitedQuery.aggregate("wb6", .average).double else {
            return responseBuilder.response(command: 0x0e, body: pwwtData)
        }
        
        let averageTendency = WorldTendency(wb1: UInt32(avg1),
                                            lr1: UInt32(0),
                                            wb2: UInt32(avg2),
                                            lr2: UInt32(0),
                                            wb3: UInt32(avg3),
                                            lr3: UInt32(0),
                                            wb4: UInt32(avg4),
                                            lr4: UInt32(0),
                                            wb5: UInt32(avg5),
                                            lr5: UInt32(0),
                                            wb6: UInt32(avg6),
                                            lr6: UInt32(0),
                                            wb7: UInt32(0),
                                            lr7: UInt32(0))
        
        return responseBuilder.response(command: 0x0e, body: averageTendency.makeData())
    }
}

