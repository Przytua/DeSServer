//
//  DBMigration.swift
//  App
//
//  Created by Łukasz Przytuła on 15.03.2018.
//

import Vapor
import FluentProvider
import Foundation

class DBMigration: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.modify(WanderingGhost.self) { builder in
            builder.int(WanderingGhost.Keys.port)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.modify(WanderingGhost.self) { builder in
            builder.delete(WanderingGhost.Keys.port)
        }
    }
}
