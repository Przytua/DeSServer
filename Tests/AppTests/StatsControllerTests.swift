import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class StatsControllerTests: TestCase {
    
    let statsController = StatsController()
    
    override func setUp() {
        try? WanderingGhost.makeQuery().delete()
        
        let replayData = "eNqF0V1IU2EYB/D/aZJRhBFR0SQotE9zsVYuykOIFiWURVlBsKTQEDI1DZwX1SqSQgwq+mJspYFoN+EuouZezp6L1II+KT9u3uUhrMB2ERQk2LOPLs44p/7w54H398AL7wvADs45QNHs5/eXBKYdJI9khwf1mFiUs5jPIRWUV/DUHH132TeQbPVEfDk1Qrkyy+DqyD52N8ne1ZHWz3liqSuY4bvYt5H8WVes7bWLlcO/Mnw3+2aSfQXqnFNrxcLOgb9+FMjT1NFcdhdJ30cL7/yPP0j7sIV3/ds/NKf8wmxzDw2xbyR50W/ux3emvK3K1LeOfGcvInnn29ObNceEu+xQwuMKUJ94n6LoWfYyihWe2TLmWyGcY20Jh4LtSXcuOMxeSbH3j57ld68XnhMDBi9Y52Wvpk/ePeHroUrhezGV8Hl8f9LX/G5nb6Jx26X++vgTcS//h8Ed7w6yd9D4w0C/Pj8iopMho/uD7FHSd/SogVfFIt7iMri71lMSxHLS61ZlOs9CTX1by36S9NvdFv6a/TTpvR0WPpTynikLH0z7LXN/40z7AXMPP2dvZF9m7o83sTewZ5l56is4M8pzAf9VKJdfQvFcm04HSnspbHO7kHWjFDOX6Mi+P8HbTdwGwPaF+5U7mdyFbQIVaIQXLbzRjCqY5A9EPG4N"
        
        let dict: [String: String] = [
            WanderingGhost.Keys.characterID: "TestPlayerName0",
            WanderingGhost.Keys.ghostBlockID: String(-10079),
            WanderingGhost.Keys.posx: String(0),
            WanderingGhost.Keys.posy: String(0),
            WanderingGhost.Keys.posz: String(0),
            WanderingGhost.Keys.replayData: replayData
        ]
        
        for port in [1, 2, 3] {
            var count = 0
            for block in StatsController.Block.cases() {
                if (block == .loadingArea) {
                    continue
                }
                for _ in 1...(count + port) {
                    let ghost = WanderingGhost(dictionary: dict)
                    ghost.port = port
                    ghost.ghostBlockID = Int32(block.rawValue)
                    try? ghost.save()
                }
                count = (count + 1) % 3
            }
        }
    }
    
    override func tearDown() {
        try? WanderingGhost.makeQuery().delete()
    }
    
    func testUsers() throws {
        XCTAssertEqual(statsController.users(), 513) // 19 + 38 + 57 + 38 + 57 + 76 + 57 + 76 + 95
        XCTAssertEqual(statsController.users(port: 1), 114) // 19 + 38 + 57
        XCTAssertEqual(statsController.users(port: 2), 171) // 38 + 57 + 76
        XCTAssertEqual(statsController.users(port: 3), 228) // 57 + 76 + 95
    }
    
    func testAreas() throws {
        let areaStats = statsController.usersInAreas()!
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.nexus })!.1, 6)
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.boletarianPalace })!.1, 48)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.bridge })!.1, 27)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.city })!.1, 27)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.kingsTower })!.1, 15)
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.stonefangTunnel })!.1, 45)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.flamelurkelTunnels })!.1, 36)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.dragonGodHallway })!.1, 18)
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.prison })!.1, 54)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.towers })!.1, 36)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.oldMonkStairs })!.1, 18)
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.shrineOfStorms })!.1, 48)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.stingraysPath })!.1, 33)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.stormKing })!.1, 21)
        
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.valleyOfDefilement })!.1, 27)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.swamp })!.1, 33)
        XCTAssertEqual((areaStats.first { $0.0 == StatsController.Area.maidenAstreaApproach })!.1, 21)
        
        let areaStats1 = statsController.usersInAreas(port: 1)!
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.nexus })!.1, 1) // 1
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.boletarianPalace })!.1, 11) // 2 + 3 + 1 + 2 + 3
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.bridge })!.1, 6) // 1 + 2 + 3
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.city })!.1, 6) // 1 + 2 + 3
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.kingsTower })!.1, 3) // 1 + 2
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.stonefangTunnel })!.1, 10) // 3 + 1 + 2 + 3 + 1
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.flamelurkelTunnels })!.1, 8) // 2 + 3 + 1 + 2
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.dragonGodHallway })!.1, 4) // 3 + 1
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.prison })!.1, 12) // 2 + 3 + 1 + 2 + 3 + 1
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.towers })!.1, 8) // 2 + 3 + 1 + 2
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.oldMonkStairs })!.1, 4) // 3 + 1
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.shrineOfStorms })!.1, 11) // 2 + 3 + 1 + 2 + 3
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.stingraysPath })!.1, 7) // 1 + 2 + 3 + 1
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.stormKing })!.1, 5) // 2 + 3
        
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.valleyOfDefilement })!.1, 6) // 1 + 2 + 3
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.swamp })!.1, 7) // 1 + 2 + 3 + 1
        XCTAssertEqual((areaStats1.first { $0.0 == StatsController.Area.maidenAstreaApproach })!.1, 5) // 2 + 3
        
        let areaStats2 = statsController.usersInAreas(port: 2)!
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.nexus })!.1, 2) // 2
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.boletarianPalace })!.1, 16) // 3 + 4 + 2 + 3 + 4
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.bridge })!.1, 9) // 2 + 3 + 4
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.city })!.1, 9) // 2 + 3 + 4
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.kingsTower })!.1, 5) // 2 + 3
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.stonefangTunnel })!.1, 15) // 4 + 2 + 3 + 4 + 2
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.flamelurkelTunnels })!.1, 12) // 3 + 4 + 2 + 3
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.dragonGodHallway })!.1, 6) // 4 + 2
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.prison })!.1, 18) // 3 + 4 + 2 + 3 + 4 + 2
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.towers })!.1, 12) // 3 + 4 + 2 + 3
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.oldMonkStairs })!.1, 6) // 4 + 2
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.shrineOfStorms })!.1, 16) // 3 + 4 + 2 + 3 + 4
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.stingraysPath })!.1, 11) // 2 + 3 + 4 + 2
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.stormKing })!.1, 7) // 3 + 4
        
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.valleyOfDefilement })!.1, 9) // 2 + 3 + 4
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.swamp })!.1, 11) // 2 + 3 + 4 + 2
        XCTAssertEqual((areaStats2.first { $0.0 == StatsController.Area.maidenAstreaApproach })!.1, 7) // 3 + 4
        
        let areaStats3 = statsController.usersInAreas(port: 3)!
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.nexus })!.1, 3) // 3
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.boletarianPalace })!.1, 21) // 4 + 5 + 3 + 4 + 5
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.bridge })!.1, 12) // 3 + 4 + 5
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.city })!.1, 12) // 3 + 4 + 5
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.kingsTower })!.1, 7) // 3 + 4
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.stonefangTunnel })!.1, 20) // 5 + 3 + 4 + 5 + 3
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.flamelurkelTunnels })!.1, 16) // 4 + 5 + 3 + 4
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.dragonGodHallway })!.1, 8) // 5 + 3
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.prison })!.1, 24) // 4 + 5 + 3 + 4 + 5 + 3
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.towers })!.1, 16) // 4 + 5 + 3 + 4
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.oldMonkStairs })!.1, 8) // 5 + 3
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.shrineOfStorms })!.1, 21) // 4 + 5 + 3 + 4 + 5
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.stingraysPath })!.1, 15) // 3 + 4 + 5 + 3
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.stormKing })!.1, 9) // 4 + 5
        
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.valleyOfDefilement })!.1, 12) // 3 + 4 + 5
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.swamp })!.1, 15) // 3 + 4 + 5 + 3
        XCTAssertEqual((areaStats3.first { $0.0 == StatsController.Area.maidenAstreaApproach })!.1, 9) // 4 + 5
    }
    
    func testBlocks() throws {
        let blockStats = statsController.usersInBlocks()!
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.nexus })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.boletarianPalace })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.boletarianPalaceUpper })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.boletarianPalaceBarracks })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.boletarianPalaceBack })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.phalanx })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.bridgeLower })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.bridgeUpper })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.towerKnight })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.cityOuter })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.cityInner })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.penetrator })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.kingsTower })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.falseKing })!.1, 9)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stonefangTunnel1 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stonefangTunnel2 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stonefangTunnel3 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stonefangTunnel4 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.armorSpider })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.tunnels })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.cliffside })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.bottom })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.flamelurker })!.1, 9)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.hallway })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.dragonGod })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.prison1 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.prison2 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.prison3 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.prison4 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.prison5 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.foolsIdol })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.towers1 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.towers2 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.towers3 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.maneater })!.1, 9)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.oldMonkStairs })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.oldMonk })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.shrineOfStorms1 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.shrineOfStorms2 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.shrineOfStorms3 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.shrineOfStorms4 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.adjudicator })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.upperStingrayPath })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.centralStingrayPath })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.lowerStingrayPath })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.oldHero })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stormKingApproach })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.stormKing })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.valleyOfDefilement1 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.valleyOfDefilement2 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.leechmonger })!.1, 12)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.swamp1 })!.1, 6)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.swamp2 })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.swamp3 })!.1, 12)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.dirtyColossus })!.1, 6)
        
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.maidenAstraeaApproach })!.1, 9)
        XCTAssertEqual((blockStats.first { $0.0 == StatsController.Block.maidenAstraea })!.1, 12)
        
        let blockStats1 = statsController.usersInBlocks(port: 1)!
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.nexus })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.boletarianPalace })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.boletarianPalaceUpper })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.boletarianPalaceBarracks })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.boletarianPalaceBack })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.phalanx })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.bridgeLower })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.bridgeUpper })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.towerKnight })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.cityOuter })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.cityInner })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.penetrator })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.kingsTower })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.falseKing })!.1, 2)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stonefangTunnel1 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stonefangTunnel2 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stonefangTunnel3 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stonefangTunnel4 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.armorSpider })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.tunnels })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.cliffside })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.bottom })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.flamelurker })!.1, 2)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.hallway })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.dragonGod })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.prison1 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.prison2 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.prison3 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.prison4 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.prison5 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.foolsIdol })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.towers1 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.towers2 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.towers3 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.maneater })!.1, 2)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.oldMonkStairs })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.oldMonk })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.shrineOfStorms1 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.shrineOfStorms2 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.shrineOfStorms3 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.shrineOfStorms4 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.adjudicator })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.upperStingrayPath })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.centralStingrayPath })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.lowerStingrayPath })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.oldHero })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stormKingApproach })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.stormKing })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.valleyOfDefilement1 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.valleyOfDefilement2 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.leechmonger })!.1, 3)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.swamp1 })!.1, 1)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.swamp2 })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.swamp3 })!.1, 3)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.dirtyColossus })!.1, 1)
        
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.maidenAstraeaApproach })!.1, 2)
        XCTAssertEqual((blockStats1.first { $0.0 == StatsController.Block.maidenAstraea })!.1, 3)
        
        let blockStats2 = statsController.usersInBlocks(port: 2)!
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.nexus })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.boletarianPalace })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.boletarianPalaceUpper })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.boletarianPalaceBarracks })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.boletarianPalaceBack })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.phalanx })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.bridgeLower })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.bridgeUpper })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.towerKnight })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.cityOuter })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.cityInner })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.penetrator })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.kingsTower })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.falseKing })!.1, 3)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stonefangTunnel1 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stonefangTunnel2 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stonefangTunnel3 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stonefangTunnel4 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.armorSpider })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.tunnels })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.cliffside })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.bottom })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.flamelurker })!.1, 3)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.hallway })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.dragonGod })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.prison1 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.prison2 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.prison3 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.prison4 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.prison5 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.foolsIdol })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.towers1 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.towers2 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.towers3 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.maneater })!.1, 3)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.oldMonkStairs })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.oldMonk })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.shrineOfStorms1 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.shrineOfStorms2 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.shrineOfStorms3 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.shrineOfStorms4 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.adjudicator })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.upperStingrayPath })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.centralStingrayPath })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.lowerStingrayPath })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.oldHero })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stormKingApproach })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.stormKing })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.valleyOfDefilement1 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.valleyOfDefilement2 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.leechmonger })!.1, 4)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.swamp1 })!.1, 2)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.swamp2 })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.swamp3 })!.1, 4)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.dirtyColossus })!.1, 2)
        
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.maidenAstraeaApproach })!.1, 3)
        XCTAssertEqual((blockStats2.first { $0.0 == StatsController.Block.maidenAstraea })!.1, 4)
        
        let blockStats3 = statsController.usersInBlocks(port: 3)!
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.nexus })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.boletarianPalace })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.boletarianPalaceUpper })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.boletarianPalaceBarracks })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.boletarianPalaceBack })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.phalanx })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.bridgeLower })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.bridgeUpper })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.towerKnight })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.cityOuter })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.cityInner })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.penetrator })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.kingsTower })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.falseKing })!.1, 4)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stonefangTunnel1 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stonefangTunnel2 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stonefangTunnel3 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stonefangTunnel4 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.armorSpider })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.tunnels })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.cliffside })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.bottom })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.flamelurker })!.1, 4)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.hallway })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.dragonGod })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.prison1 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.prison2 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.prison3 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.prison4 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.prison5 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.foolsIdol })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.towers1 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.towers2 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.towers3 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.maneater })!.1, 4)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.oldMonkStairs })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.oldMonk })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.shrineOfStorms1 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.shrineOfStorms2 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.shrineOfStorms3 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.shrineOfStorms4 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.adjudicator })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.upperStingrayPath })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.centralStingrayPath })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.lowerStingrayPath })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.oldHero })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stormKingApproach })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.stormKing })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.valleyOfDefilement1 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.valleyOfDefilement2 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.leechmonger })!.1, 5)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.swamp1 })!.1, 3)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.swamp2 })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.swamp3 })!.1, 5)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.dirtyColossus })!.1, 3)
        
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.maidenAstraeaApproach })!.1, 4)
        XCTAssertEqual((blockStats3.first { $0.0 == StatsController.Block.maidenAstraea })!.1, 5)
    }
    
    func testStatusMessage() throws {
        XCTAssertEqual(statsController.serverStatusMessage(port: 1), "Online users: 114\r\n3-1 Prison of Hope: 12 players\r\n4-1 Shrine of Storms: 11 players\r\n1-1 Boletarian Palace: 11 players\r\n2-1 Stonefang Tunnel: 10 players\r\n3-2 Towers: 8 players\r\n")
        XCTAssertEqual(statsController.serverStatusMessage(port: 2), "Online users: 171\r\n3-1 Prison of Hope: 18 players\r\n4-1 Shrine of Storms: 16 players\r\n1-1 Boletarian Palace: 16 players\r\n2-1 Stonefang Tunnel: 15 players\r\n3-2 Towers: 12 players\r\n")
        XCTAssertEqual(statsController.serverStatusMessage(port: 3), "Online users: 228\r\n3-1 Prison of Hope: 24 players\r\n4-1 Shrine of Storms: 21 players\r\n1-1 Boletarian Palace: 21 players\r\n2-1 Stonefang Tunnel: 20 players\r\n3-2 Towers: 16 players\r\n")
    }
}

// MARK: Manifest

extension StatsControllerTests {
    static let allTests = [
        ("testUsers", testUsers),
    ]
}
