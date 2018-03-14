//
//  MessagesController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class MessagesController {
    
    let decryptor = Decryptor()
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    let playersController: PlayersController
    
    init(redirectController: RedirectController, playersController: PlayersController) {
        self.redirectController = redirectController
        self.playersController = playersController
    }
    
    func addBloodMessage(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        let bloodMessage = BloodMessage(dictionary: dictionary)
        try bloodMessage.save()
        
        return responseBuilder.response(command: 0x1d, body: Data(bytes: [0x01]))
    }
    
    func updateBloodMessageGrade(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let bmIDString = dictionary["bmID"],
              let bmID = UInt32(bmIDString),
              let bloodMessage = try BloodMessage.find(bmID) else {
            return Response(status: .badRequest)
        }
        
        try BloodMessage.database?.raw("UPDATE blood_messages SET \(BloodMessage.Keys.rating) = \(BloodMessage.Keys.rating) + 1 WHERE \(BloodMessage.Keys.id) = \(bmID)")
        try playersController.updateBloodMessageGrade(characterID: bloodMessage.characterID)
        
        return responseBuilder.response(command: 0x2a, body: Data(bytes: [0x01]))
    }
    
    func getBloodMessage(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let blockIDString = dictionary["blockID"],
              let blockID = Int32(blockIDString),
              let replayNumString = dictionary["replayNum"],
              var limit = Int(replayNumString),
              let characterID = dictionary["characterID"] else {
            return Response(status: .badRequest)
        }
        
        var messages: [BloodMessage] = []
        
        if let myMessages = try? BloodMessage.makeQuery().filter("blockID", .equals,  blockID).filter("characterID", .equals, characterID).limit(limit).all() {
            messages.append(contentsOf: myMessages)
            limit -= myMessages.count
        }
        if let topMessages = try? BloodMessage.makeQuery().filter("blockID", .equals, blockID).sort("rating", .descending).limit(limit).all() {
            messages.append(contentsOf: topMessages)
            limit -= topMessages.count
        }
        
        var serializedMessages = Data()
        serializedMessages.append(toData(from: UInt32(messages.count)))
        for message in messages {
            serializedMessages.append(message.makeData())
        }
        
        return responseBuilder.response(command: 0x1f, body: serializedMessages)
    }
    
    func deleteBloodMessage(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let bmIDString = dictionary["bmID"],
              let bmID = UInt32(bmIDString),
              let bloodMessage = try BloodMessage.find(bmID) else {
            return Response(status: .badRequest)
        }
        
        try bloodMessage.delete()
        
        return responseBuilder.response(command: 0x27, body: Data(bytes: [0x01]))
    }
    
    func getBloodMessageGrade(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let NPID = dictionary["NPID"] else {
            return Response(status: .badRequest)
        }
        
        var responseData = Data(bytes: [0x01])
        guard let ratings = try BloodMessage.makeQuery().filter("characterID", .equals, NPID).aggregate("rating", .sum).int else {
            return Response(status: .internalServerError)
        }
        responseData.append(toData(from: UInt32(ratings)))
        return responseBuilder.response(command: 0x29, body: responseData)
    }
}
