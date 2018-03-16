//
//  StatsController.swift
//  App
//
//  Created by Łukasz Przytuła on 16.03.2018.
//

import Foundation

class StatsController {
    
    enum Block: Int {
        case loadingArea = -1
        case nexus = -10079
        case boletarianPalace = 20070
        case boletarianPalaceUpper = 20071
        case boletarianPalaceBarracks = 20072
        case boletarianPalaceBack = 20073
        case phalanx = -20079
        case bridgeLower = 20170
        case bridgeUpper = 20171
        case towerKnight = -20179
        case cityOuter = 20270
        case cityInner = 20271
        case penetrator = -20279
        case kingsTower = 20370
        case falseKing = -20379
        case stonefangTunnel1 = 60070
        case stonefangTunnel2 = 60071
        case stonefangTunnel3 = 60072
        case stonefangTunnel4 = 60073
        case armorSpider = -60079
        case tunnels = 60170
        case cliffside = 60171
        case bottom = 60172
        case flamelurker = -60179
        case hallway = 60270
        case dragonGod = -60279
        case prison1 = 40070
        case prison2 = 40071
        case prison3 = 40072
        case prison4 = 40073
        case prison5 = 40074
        case foolsIdol = -40079
        case towers1 = 40170
        case towers2 = 40171
        case towers3 = 40172
        case maneater = -40179
        case oldMonkStairs = 40270
        case oldMonk = 1040271
        case shrineOfStorms1 = 30170
        case shrineOfStorms2 = 30171
        case shrineOfStorms3 = 30172
        case shrineOfStorms4 = 30173
        case adjudicator = -30179
        case upperStingrayPath = 30270
        case centralStingrayPath = 30271
        case lowerStingrayPath = 30272
        case oldHero = -30279
        case stormKingApproach = 30370
        case stormKing = -30379
        case valleyOfDefilement1 = 50070
        case valleyOfDefilement2 = 50071
        case leechmonger = -50079
        case swamp1 = 50170
        case swamp2 = 50171
        case swamp3 = 50172
        case dirtyColossus = -50179
        case maidenAstraeaApproach = 50270
        case maidenAstraea = -50279
        
        var name: String {
            get {
                switch self {
                case .loadingArea: return "Loading area"
                case .nexus: return "Nexus"
                case .boletarianPalace: return "1-1 Boletarian Palace"
                case .boletarianPalaceUpper: return "1-1 Boletarian Palace Upper"
                case .boletarianPalaceBarracks: return "1-1 Boletarian Place Barracks"
                case .boletarianPalaceBack: return "1-1 Boletarian Palace Back"
                case .phalanx: return "1-1 Phalanx"
                case .bridgeLower: return "1-2 Bridge Lower"
                case .bridgeUpper: return "1-2 Bridge Upper"
                case .towerKnight: return "1-2 Tower Knight"
                case .cityOuter: return "1-3 City Outer"
                case .cityInner: return "1-3 City Inner"
                case .penetrator: return "1-3 Penetrator"
                case .kingsTower: return "1-4 King's Tower"
                case .falseKing: return "1-4 False King"
                case .stonefangTunnel1: return "2-1 Stonefang Tunnel 1"
                case .stonefangTunnel2: return "2-1 Stonefang Tunnel 2"
                case .stonefangTunnel3: return "2-1 Stonefang Tunnel 3"
                case .stonefangTunnel4: return "2-1 Stonefang Tunnel 4"
                case .armorSpider: return "2-1 Armor Spider"
                case .tunnels: return "2-2 Tunnels"
                case .cliffside: return "2-2 Cliffside"
                case .bottom: return "2-2 Bottom"
                case .flamelurker: return "2-2 Flamelurker"
                case .hallway: return "2-3 Hallway"
                case .dragonGod: return "2-3 Dragon God"
                case .prison1: return "3-1 Prison 1"
                case .prison2: return "3-1 Prison 2"
                case .prison3: return "3-1 Prison 3"
                case .prison4: return "3-1 Prison 4"
                case .prison5: return "3-1 Prison 5"
                case .foolsIdol: return "3-1 Fool's Idol"
                case .towers1: return "3-2 Towers 1"
                case .towers2: return "3-2 Towers 2"
                case .towers3: return "3-2 Towers 3"
                case .maneater: return "3-2 Maneater"
                case .oldMonkStairs: return "3-3 Old Monk Stairs"
                case .oldMonk: return "3-3 Old Monk"
                case .shrineOfStorms1: return "4-1 Shrine of Stroms 1"
                case .shrineOfStorms2: return "4-1 Shrine of Stroms 2"
                case .shrineOfStorms3: return "4-1 Shrine of Stroms 3"
                case .shrineOfStorms4: return "4-1 Shrine of Stroms 4"
                case .adjudicator: return "4-1 Adjucator"
                case .upperStingrayPath: return "4-2 Upper Stingray Path"
                case .centralStingrayPath: return "4-2 Central Stingray Path"
                case .lowerStingrayPath: return "4-2 Lower Stingray Path"
                case .oldHero: return "4-2 Old Hero"
                case .stormKingApproach: return "4-3 Storm King Approach"
                case .stormKing: return "4-3 Storm King"
                case .valleyOfDefilement1: return "5-1 Valley of Defilement 1"
                case .valleyOfDefilement2: return "5-1 Valley of Defilement 2"
                case .leechmonger: return "5-1 Leechmonger"
                case .swamp1: return "5-2 Swamp 1"
                case .swamp2: return "5-2 Swamp 2"
                case .swamp3: return "5-2 Swamp 3"
                case .dirtyColossus: return "5-2 Dirty Colossus"
                case .maidenAstraeaApproach: return "5-3 Maiden Astraea Approach"
                case .maidenAstraea: return "5-3 Maiden Astraea"
                }
            }
        }
        
        public static func cases() -> AnySequence<Block> {
            return AnySequence { () -> AnyIterator<Block> in
                var raw = 0
                return AnyIterator {
                    let current: Block = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                    guard current.hashValue == raw else {
                        return nil
                    }
                    raw += 1
                    return current
                }
            }
        }
    }
    
    enum Area: String {
        case nexus = "Nexus"
        
        case boletarianPalace = "1-1 Boletarian Palace"
        case bridge = "1-2 Bridge"
        case city = "1-3 City"
        case kingsTower = "1-4 King's Tower"
        
        case stonefangTunnel = "2-1 Stonefang Tunnel"
        case flamelurkelTunnels = "2-2 Flamelurker Tunnels"
        case dragonGodHallway = "2-3 Dragon God Hallway"
        
        case prison = "3-1 Prison of Hope"
        case towers = "3-2 Towers"
        case oldMonkStairs = "3-3 Old Monk Stairs"
        
        case shrineOfStorms = "4-1 Shrine of Storms"
        case stingraysPath = "4-2 Stingrays Path"
        case stormKing = "4-3 Storm King Approach"
        
        case valleyOfDefilement = "5-1 Valley of Defilement"
        case swamp = "5-2 Swamp"
        case maidenAstreaApproach = "5-3 Maiden Astrea Approach"
        
        init?(with block: Block) {
            self.init(with: block.rawValue)
        }
        
        init?(with blockID: Int) {
            switch abs(blockID) {
            case 10079:
                self = .nexus
                
            case 20000..<20100:
                self = .boletarianPalace
            case 20100..<20200:
                self = .bridge
            case 20200..<20300:
                self = .city
            case 20300..<20400:
                self = .kingsTower
                
            case 60000..<60100:
                self = .stonefangTunnel
            case 60100..<60200:
                self = .flamelurkelTunnels
            case 60200..<60300:
                self = .dragonGodHallway
                
            case 40000..<40100:
                self = .prison
            case 40100..<40200:
                self = .towers
            case 40200..<40300, 1040271:
                self = .oldMonkStairs
                
            case 30100..<30200:
                self = .shrineOfStorms
            case 30200..<30300:
                self = .stingraysPath
            case 30300..<30400:
                self = .stormKing
                
            case 50000..<50100:
                self = .valleyOfDefilement
            case 50100..<50200:
                self = .swamp
            case 50200..<50300:
                self = .maidenAstreaApproach
                
            default:
                return nil
            }
        }
    }
    
    func users(port: Int? = nil) -> Int {
        guard let port = port else {
            return (try? WanderingGhost.count()) ?? 0
        }
        return (try? WanderingGhost.makeQuery().filter("port", .equals, port).count()) ?? 0
    }
    
    func usersInAreas(port: Int? = nil) -> [(Area, Int)]? {
        guard let blockStats = usersInBlocks(port: port) else {
            return nil
        }
        
        var areasDict: [Area: Int] = [:]
        for (blockID, blockCount) in blockStats {
            guard let areaKey = Area(with: blockID) else {
                continue
            }
            let newCount = (areasDict[areaKey] ?? 0) + blockCount
            areasDict[areaKey] = newCount
        }
        
        return areasDict.sorted(by: { $0.value > $1.value })
    }
    
    func usersInBlocks(port: Int? = nil) -> [(Block, Int)]? {
        let portFilter: String
        if let port = port {
            portFilter = "WHERE \"port\" = \(port)"
        } else {
            portFilter = ""
        }
        
        guard let blockStats = try? WanderingGhost.database!.raw("SELECT \"ghostBlockID\", COUNT(*) FROM wandering_ghosts \(portFilter) GROUP BY \"ghostBlockID\" ORDER BY count DESC"),
              let blockStatsArray = blockStats.array,
              blockStatsArray.count > 0 else {
            return nil
        }
        
        return blockStatsArray.map { (Block(rawValue: $0["ghostBlockID"]!.int!)!, $0["count"]!.int!) }
    }
    
    func serverStatusMessage(port: Int) -> String {
        let users = self.users(port: port)
        var message = "Online users: \(users)\r\n"
        
        guard let areaStats = usersInAreas(port: port) else {
            return message
        }
        
        var areas = 0
        for (area, count) in areaStats {
            message.append("\(area.rawValue): \(count) \(count == 1 ? "player" : "players")\r\n")
            areas += 1
            if (areas == 5) {
                break
            }
        }
        
        return message
    }
    
    
    func cleanupOldGhosts(_ oldestTimestamp: Date) {
        let oldestTimestamp = Date(timeIntervalSinceNow: -TimeInterval(wanderingGhostInterval))
        try? WanderingGhost.makeQuery()
             .filter("timestamp", .lessThan, oldestTimestamp)
             .delete()
    }
}
