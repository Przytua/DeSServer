//
//  InfoController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class InfoController {
    
    let euResponse: String
    let jpResponse: String
    let usResponse: String
    
    init(config: Config) {
        let serverConfiguration = SoulsServerConfiguration()
        let serverAddress = config["server", "host"]?.string ?? "0.0.0.0"
        euResponse = serverConfiguration.euResponse(serverAddress: serverAddress)
        jpResponse = serverConfiguration.jpResponse(serverAddress: serverAddress)
        usResponse = serverConfiguration.usResponse(serverAddress: serverAddress)
    }
    
    func eu(_ request: Request) -> ResponseRepresentable {
        return euResponse
    }
    
    func jp(_ request: Request) -> ResponseRepresentable {
        return jpResponse
    }
    
    func us(_ request: Request) -> ResponseRepresentable {
        return usResponse
    }
}
