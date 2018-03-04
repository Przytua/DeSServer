//
//  InfoController.swift
//  App
//
//  Created by Łukasz Przytuła on 04.03.2018.
//

import Vapor
import Foundation

class InfoController {
    
    func eu(_ request: Request) -> ResponseRepresentable {
        return SoulsServerConfiguration.euResponse
    }
    
    func jp(_ request: Request) -> ResponseRepresentable {
        return SoulsServerConfiguration.jpResponse
    }
    
    func us(_ request: Request) -> ResponseRepresentable {
        return SoulsServerConfiguration.usResponse
    }
}
