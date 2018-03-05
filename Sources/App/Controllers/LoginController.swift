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
    
    func login(_ request: Request) -> Response {
        _ = redirectController.redirect(request)
        
        var responseData: Data = Data(bytes: [1, 1]) //1, 244, 2, 0, 0,
        let message = "Custom message"
        responseData.append(message.data(using: .utf8)!)
        responseData.append([0], count: 1)
        
        return self.responseBuilder.response(command: 0x01, body: responseData)
    }
    
    func getQWCData(_ request: Request) -> Response {
        _ = redirectController.redirect(request)
        
        let bytes: [UInt8]
        let pureBlack = false
        if (pureBlack) {
            bytes = [0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PBWT
        } else {
            bytes = [0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PWWT
        }// 14, 61, 0, 0, 0, 
        let data = Data(bytes: bytes)
        return self.responseBuilder.response(command: 0x0e, body: data)
    }
}
