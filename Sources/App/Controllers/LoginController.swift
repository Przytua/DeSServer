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
        
        var responseData: Data = Data(bytes: [1, 244, 2, 0, 0, 1, 1])
        let message = "Custom message"
        responseData.append(message.data(using: .utf8)!)
        responseData.append([0], count: 1)
        
        return self.responseBuilder.response(with: responseData)
    }
    
    func getQWCData(_ request: Request) -> Response {
        _ = redirectController.redirect(request)
        
        let bytes: [UInt8]
        let pureBlack = false
        if (pureBlack) {
            bytes = [14, 61, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PBWT
        } else {
            bytes = [14, 61, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] // PWWT
        }
        let data = Data(bytes: bytes)
        return self.responseBuilder.response(with: data)
    }
}
