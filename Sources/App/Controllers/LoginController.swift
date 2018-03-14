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
        
        var responseData: Data = Data(bytes: [1, 1])
        let message = "Custom message"
        responseData.append(message.data(using: .utf8)!)
        responseData.append([0], count: 1)
        
        return self.responseBuilder.response(command: 0x01, body: responseData)
    }
}
