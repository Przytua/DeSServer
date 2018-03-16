//
//  StatsViewController.swift
//  App
//
//  Created by Łukasz Przytuła on 16.03.2018.
//

import Vapor
import Foundation

class StatsViewController {
    
    public let viewRenderer: ViewRenderer
    let statsController = StatsController()
    
    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }
    
    func stats(_ req: Request) throws -> ResponseRepresentable {
        try? WanderingGhost.makeQuery().delete()
        let euPlayers = statsController.users(port: 18000)
        let jpPlayers = statsController.users(port: 18100)
        let usPlayers = statsController.users(port: 18100)
        var variables: [String: Any] = [
            "euPlayers": euPlayers,
            "jpPlayers": jpPlayers,
            "usPlayers": usPlayers,
        ]
        if let euBlocksStats = statsController.usersInBlocks(port: 18000) {
            variables["euBlocksStats"] = try json(from: euBlocksStats)
        }
        if let jpBlocksStats = statsController.usersInBlocks(port: 18100) {
            variables["jpBlocksStats"] = try json(from: jpBlocksStats)
        }
        if let usBlocksStats = statsController.usersInBlocks(port: 18200) {
            variables["usBlocksStats"] = try json(from: usBlocksStats)
        }
        return try self.viewRenderer.make("stats", variables)
    }
    
    func json(from stats: [(StatsController.Block, Int)]) throws -> [JSON] {
        var jsonArray: [JSON] = []
        for (block, count) in stats {
            var json = JSON()
            try json.set("block", block.name)
            try json.set("count", count)
            jsonArray.append(json)
        }
        return jsonArray
    }
}
