//
//  PlayersController.swift
//  App
//
//  Created by Łukasz Przytuła on 14.03.2018.
//

import Foundation

class PlayersController {
    
    let decryptor = Decryptor()
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    
    let gradeNames = [Player.Keys.gradeS, Player.Keys.gradeA, Player.Keys.gradeB, Player.Keys.gradeC, Player.Keys.gradeD]
    
    init(redirectController: RedirectController) {
        self.redirectController = redirectController
    }
    
    func initializeCharacter(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard var characterID = dictionary["characterID"],
              let index = dictionary["index"] else {
            return Response(status: .badRequest)
        }
        
        characterID.append(index)
        
        if (try Player.makeQuery().filter("characterID", .equals, characterID).first()) == nil {
            let player = Player(characterID: characterID)
            try? player.save()
        }
        
        var responseData = characterID.data(using: .utf8)!
        responseData.append([0], count: 1)
        return responseBuilder.response(command: 0x17, body: responseData)
    }
    
    func getMultiPlayGrade(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let NPID = dictionary["NPID"]  else {
            return Response(status: .badRequest)
        }
        
        guard let player = try Player.makeQuery().filter("characterID", .equals, NPID).first() else {
            return Response(status: .badRequest)
        }
        
        var responseData = Data(bytes: [0x01])
        responseData.append(player.makeData())
        return responseBuilder.response(command: 0x28, body: responseData)
    }
    
    func updateBloodMessageGrade(characterID: String) throws {
        try Player.database?.raw("UPDATE 'players' SET \(Player.Keys.messagesRating) = \(Player.Keys.messagesRating) + 1 WHERE \(Player.Keys.characterID) = \(characterID)")
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
        guard let player = try Player.makeQuery().filter("characterID", .equals, NPID).first() else {
            return Response(status: .internalServerError)
        }
        responseData.append(toData(from: player.messagesRating))
        return responseBuilder.response(command: 0x29, body: responseData)
    }
    
    func initializeMultiPlay(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let characterID = dictionary["characterID"] else {
            return Response(status: .badRequest)
        }

        try Player.database?.raw("UPDATE 'players' SET \(Player.Keys.numberOfSessions) = \(Player.Keys.numberOfSessions) + 1 WHERE \(Player.Keys.characterID) = \(characterID)")
        
        return responseBuilder.response(command: 0x15, body: Data(bytes: [0x01]))
    }
    
    func finalizeMultiPlay(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
            let requestData = decryptor.decrypt(body) else {
                return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard let characterID = dictionary["characterID"] else {
            return Response(status: .badRequest)
        }
        
        for gradeName in gradeNames {
            if let grade = dictionary[gradeName], grade == "1" {
                try update(grade: gradeName, player: characterID)
                break
            }
        }
        
        return responseBuilder.response(command: 0x21, body: Data(bytes: [0x01]))
    }
    
    func updateOtherPlayerGrade(_ request: Request) throws -> Response {
        _ = redirectController.redirect(request)
        
        guard let body = request.body.bytes,
              let requestData = decryptor.decrypt(body) else {
            return Response(status: .badRequest)
        }
        let dictionary = toDictionary(from: requestData)
        
        guard var characterID = dictionary["characterID"],
              let gradeString = dictionary["grade"],
              let grade = Int(gradeString) else {
            return Response(status: .badRequest)
        }
        characterID.append("0")
        let gradeName = gradeNames[grade]
        
        try update(grade: gradeName, player: characterID)
        
        return responseBuilder.response(command: 0x21, body: Data(bytes: [0x01]))
    }
    
    func update(grade gradeName: String, player characterID: String) throws {
        try Player.database?.raw("UPDATE 'players' SET \(gradeName) = \(gradeName) + 1 WHERE \(Player.Keys.characterID) = \(characterID)")
    }
}
