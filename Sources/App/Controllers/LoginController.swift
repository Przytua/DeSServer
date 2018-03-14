//
//  LoginController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class LoginController {
    
    let redirectController: RedirectController
    let responseBuilder = ResponseBuilder()
    
    init(redirectController: RedirectController) {
        self.redirectController = redirectController
    }
    
    enum LoginStatus: UInt8 {
        case presentEULA = 0x00
        case presentMOTD = 0x01
        case accountSuspended = 0x02
        case accountBanned = 0x03
        case undergoingMaintenance = 0x05
        case onlineServiceTerminated = 0x06
        case wrongClientVersion = 0x07
    }
    
    func login(_ request: Request) -> Response {
        _ = redirectController.redirect(request)
        
        let messages = ["Custom message"]
        let messagesCount = UInt8(messages.count)
        
        var responseData: Data = Data(bytes: [LoginStatus.presentMOTD.rawValue, messagesCount])
        for message in messages {
            responseData.append(message.data(using: .utf8)!)
            responseData.append([0], count: 1)
        }
        
        return self.responseBuilder.response(command: 0x01, body: responseData)
    }
    
    enum TimeMessageStatus: UInt8 {
        case ok = 0x00
        case undergoingMaintenance = 0x01
        case onlineServiceTerminated = 0x02
    }
    
    func getTimeMessage(_ request: Request) -> Response {
        _ = redirectController.redirect(request)
        
        return self.responseBuilder.response(command: 0x01, body: Data(bytes: [TimeMessageStatus.ok.rawValue, 0, 0]))
    }
}
